//
//  WaxpeerSocketDelegate.swift
//  
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import SocketIO

/// Protocol defining the delegate methods for Waxpeer socket events.
public protocol WaxpeerSocketDelegate: AnyObject {
    /// Called when the Waxpeer socket connects successfully.
    func waxpeerSocketDidConnect(_ socket: WaxpeerSocketManager) async
    
    /// Called when the Waxpeer socket disconnects.
    func waxpeerSocketDidDisconnect(_ socket: WaxpeerSocketManager) async
    
    /// Called when the Waxpeer socket receives a game item event.
    func waxpeerSocket(_ socket: WaxpeerSocketManager, didReceiveGameItem item: GameItem, event: WaxpeerGameItemEvent) async
    
    /// Called when the Waxpeer socket updates connection status.
    func waxpeeerSocket(_ socket: WaxpeerSocketManager, didUpdateStatus status: SocketConnectionStatus) async
}
