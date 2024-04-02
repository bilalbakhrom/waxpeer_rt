//
//  WebSocketProtocol.swift
//  
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

/// Protocol defining the methods required for WebSocket functionality.
public protocol WebSocketProtocol {
    /// Connects to the WebSocket server.
    func connect()
    
    /// Disconnects from the WebSocket server.
    func disconnect()
}
