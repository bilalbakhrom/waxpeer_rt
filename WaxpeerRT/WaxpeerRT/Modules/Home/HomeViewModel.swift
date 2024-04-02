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
    // MARK: - Published Properties
    
    /// Debounced list of game items.
    @Published var debouncedItems: [GameItem] = []
    
    /// Indicates whether the device is currently connected to the network.
    @Published var isConnected: Bool = false
    
    /// The current scroll offset of the content.
    @Published var scrollOffset: CGPoint = .zero
    
    /// Indicates whether auto connect feature is enabled.
    @Published var isAutoConnectEnabled: Bool = false
    
    /// Indicates the network reachability status.
    @Published var isNetworkReachable: Bool = true
    
    /// Indicates whether to show status change.
    @Published var showsStatusChange: Bool = false
    
    /// Indicates whether to show the no connection alert.
    @Published var showsNoConnectionAlert: Bool = false
    
    /// The current status of socket connection.
    @Published var status: SocketConnectionStatus = .notConnected
    
    // MARK: - Private Properties
    
    private let coordinator: HomeCoordinator
    private let socketManager: WaxpeerSocketManager
    private let networkMonitor: NetworkReachabilityMonitor
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
    
    // MARK: - Initialization
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self.socketManager = coordinator.deps.socketManager
        self.networkMonitor = coordinator.deps.networkMonitor
        super.init()
        
        socketManager.delegate = self
        networkMonitor.delegate = self
        networkMonitor.start()
    }
}

// MARK: - INTERNAL MODELS

extension HomeViewModel {
    /// Enum representing view events.
    enum ViewEvent {
        case connect
        case disconnect
        case autoConnect
        case endConnectionWithAutoRestore
        case scrollContentToTop
        case showNoConnection
    }
}

// MARK: - EVENTS

@MainActor
extension HomeViewModel {
    /// Handles view events asynchronously.
    func onViewEvent(_ event: ViewEvent) async {
        switch event {
        case .connect:
            handleConnect()
            
        case .disconnect:
            handleDisconnect()
            
        case .autoConnect:
            handleAutoConnect()
            
        case .endConnectionWithAutoRestore:
            handleEndConnection()
            
        case .scrollContentToTop:
            scrollToTopPublisherSubject.send()
            
        case .showNoConnection:
            showsNoConnectionAlert = true
        }
    }
    
    // MARK: - Private Methods
    
    private func handleConnect() {
        guard !isConnected else { return }
        
        if !isNetworkReachable {
            showsNoConnectionAlert = true
            return
        }
        
        showsStatusChange = true
        socketManager.connect()
    }
    
    private func handleDisconnect() {
        guard isConnected else { return }
        
        showsStatusChange = true
        isAutoConnectEnabled = false
        socketManager.disconnect()
    }
    
    private func handleAutoConnect() {
        guard isAutoConnectEnabled else { return }
        
        if !isNetworkReachable {
            showsNoConnectionAlert = true
            return
        }
        
        showsStatusChange = true
        isAutoConnectEnabled = false
        socketManager.connect()
    }
    
    private func handleEndConnection() {
        guard isConnected else { return }
        
        showsStatusChange = true
        isAutoConnectEnabled = true
        socketManager.disconnect()
    }
}

// MARK: - WaxpeerSocketDelegate

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
    
    // MARK: - Private Item Handling
    
    private func appendItem(_ item: GameItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
                        
            self.semaphore.wait()
            self.items.append(item)
            self.semaphore.signal()
        }
    }
    
    private func removeItem(_ item: GameItem) {
        guard let index = items.firstIndex(of: item), index < items.count else { return }
                    
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
                        
            self.semaphore.wait()
            self.items.remove(at: index)
            self.semaphore.signal()
        }
    }
    
    private func updateItem(_ item: GameItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            self.semaphore.wait()
            
            if let index = self.items.firstIndex(of: item), index < self.items.count {
                self.items[index] = item
            } else {
                self.items.append(item)
            }
            
            self.semaphore.signal()
        }
    }
}

// MARK: - NetworkReachabilityMonitorDelegate

@MainActor
extension HomeViewModel: NetworkReachabilityMonitorDelegate {
    func networkReachabilityMonitorDidUpdateStatus(_ monitor: NetworkReachabilityMonitor, isReachable: Bool) async {
        isNetworkReachable = isReachable
    }
}
