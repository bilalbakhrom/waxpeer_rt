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
    
    public init(socketManager: WaxpeerSocketManager) {
        self.socketManager = socketManager
    }
}
