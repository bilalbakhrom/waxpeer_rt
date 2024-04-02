//
//  SocketConnectionStatus.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-03.
//

import Foundation
import SocketIO

public enum SocketConnectionStatus: Int, CustomStringConvertible {
    // MARK: Cases

    /// The client/manager has never been connected. Or the client has been reset.
    case notConnected

    /// The client/manager was once connected, but not anymore.
    case disconnected

    /// The client/manager is in the process of connecting.
    case connecting

    /// The client/manager is currently connected.
    case connected
    
    // MARK: Initialization
    
    public init?(_ status: SocketIOStatus) {
        switch status {
        case .notConnected:
            self = .notConnected
        case .disconnected:
            self = .disconnected
        case .connecting:
            self = .connecting
        case .connected:
            self = .connected
        }
    }

    // MARK: Properties

    /// - returns: True if this client/manager is connected/connecting to a server.
    public var active: Bool {
        return self == .connected || self == .connecting
    }

    public var description: String {
        switch self {
        case .connected:    return "Connected"
        case .connecting:   return "Connecting"
        case .disconnected: return "Disconnected"
        case .notConnected: return "Not Connected"
        }
    }
}
