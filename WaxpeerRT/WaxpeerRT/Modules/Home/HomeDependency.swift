//
//  HomeDependency.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import AppNetwork

public struct HomeDependency {
    public let socketManager: WaxpeerSocketManager
    public let networkMonitor: NetworkReachabilityMonitor
    
    public init(
        socketManager: WaxpeerSocketManager,
        networkMonitor: NetworkReachabilityMonitor = .init()
    ) {
        self.socketManager = socketManager
        self.networkMonitor = networkMonitor
    }
}
