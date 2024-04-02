//
//  HomeViewModel.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import AppBaseController
import AppNetwork
import Combine

final class HomeViewModel: BaseViewModel {
    @Published var debouncedItems: [GameItem] = []
    @Published var isConnected: Bool = false
    @Published var scrollOffset: CGPoint = .zero
    @Published var isAutoConnectEnabled: Bool = false
    @Published var status: SocketConnectionStatus = .notConnected
    @Published var showsStatusChange: Bool = false
    
    private let coordinator: HomeCoordinator
    private let socketManager: WaxpeerSocketManager
    private let semaphore = DispatchSemaphore(value: 1)
    private var itemPublisherSubject = PassthroughSubject<[GameItem], Never>()
    private var scrollToTopPublisherSubject = PassthroughSubject<Void, Never>()
    
    private var items: [GameItem] = [] {
        didSet { itemPublisherSubject.send(items) }
    }
    
    var itemPublisher: AnyPublisher<[GameItem], Never> {
        itemPublisherSubject.eraseToAnyPublisher()
    }
    
    var scrollToTopPublisher: AnyPublisher<Void, Never> {
        scrollToTopPublisherSubject.eraseToAnyPublisher()
    }
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self.socketManager = coordinator.deps.socketManager
        super.init()
        
        self.socketManager.delegate = self
    }
}

// MARK: - INTERNAL MODELS

extension HomeViewModel {
    enum ViewEvent {
        case connect
        case disconnect
        case autoconnect
        case endConnectionWithAutoRestore
        case scrollContentToTop
    }
}

// MARK: - EVENTS

@MainActor
extension HomeViewModel {
    func onViewEvent(_ event: ViewEvent) async {
        switch event {
        case .connect:
            guard !isConnected else { return }
            showsStatusChange = true
            socketManager.connect()
            
        case .disconnect:
            guard isConnected else { return }
            showsStatusChange = true
            isAutoConnectEnabled = false
            socketManager.disconnect()
            
        case .autoconnect:
            guard isAutoConnectEnabled else { return }
            showsStatusChange = true
            isAutoConnectEnabled = false
            socketManager.connect()
            
        case .endConnectionWithAutoRestore:
            guard isConnected else { return }
            showsStatusChange = true
            isAutoConnectEnabled = true
            socketManager.disconnect()
            
        case .scrollContentToTop:
            scrollToTopPublisherSubject.send()
        }
    }
}

@MainActor
extension HomeViewModel: WaxpeerSocketDelegate {
    func waxpeerSocketDidConnect(_ socket: WaxpeerSocketManager) async {
        isConnected = true
    }
    
    func waxpeerSocketDidDisconnect(_ socket: WaxpeerSocketManager) async {
        isConnected = false
    }
    
    func waxpeeerSocket(_ socket: WaxpeerSocketManager, didUpdateStatus status: SocketConnectionStatus) async {
        self.status = status
    }
    
    func waxpeerSocket(_ socket: WaxpeerSocketManager, didReceiveGameItem item: GameItem, event: WaxpeerGameItemEvent) async {
        switch event {
        case .new:
            appendItem(item)
            
        case .removed:
            removeItem(item)
            
        case .update:
            updateItem(item)
        }
    }
    
    private func appendItem(_ item: GameItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
                        
            semaphore.wait()
            items.append(item)
            semaphore.signal()
        }
    }
    
    private func removeItem(_ item: GameItem) {
        guard let index = items.firstIndex(of: item), index < items.count else { return }
                    
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            guard let index = items.firstIndex(of: item), index < items.count else { return }
                        
            semaphore.wait()
            items.remove(at: index)
            semaphore.signal()
        }
    }
    
    private func updateItem(_ item: GameItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            semaphore.wait()
            
            if let index = items.firstIndex(of: item), index < items.count {
                items[index] = item
            } else {
                items.append(item)
            }
            
            semaphore.signal()
        }
    }
}
