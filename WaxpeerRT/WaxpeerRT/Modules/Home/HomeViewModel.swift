//
//  HomeViewModel.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import AppBaseController
import AppNetwork

final class HomeViewModel: BaseViewModel {
    @Published var items: [GameItem] = []
    @Published var debouncedItems: [GameItem] = []
    @Published var isConnected: Bool = false
    
    private let coordinator: HomeCoordinator
    private let socketManager: WaxpeerSocketManager
    private let semaphore = DispatchSemaphore(value: 1)
    
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
    }
}

// MARK: - EVENTS

@MainActor
extension HomeViewModel {
    func onViewEvent(_ event: ViewEvent) async {
        switch event {
        case .connect:
            socketManager.connect()
            
        case .disconnect:
            socketManager.disconnect()
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
                        
            semaphore.wait()
            items.append(item)
            semaphore.signal()
        }
    }
    
    private func removeItem(_ item: GameItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let index = items.firstIndex(of: item), index < items.count else { return }
                        
            semaphore.wait()
            items.remove(at: index)
            semaphore.signal()
        }
    }
    
    private func updateItem(_ item: GameItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let index = items.firstIndex(of: item), index < items.count else { return }
                        
            semaphore.wait()
            items[index] = item
            semaphore.signal()
        }
    }
}
