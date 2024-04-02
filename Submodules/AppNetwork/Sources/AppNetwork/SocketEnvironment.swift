//
//  SocketEnvironment.swift
//  
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import SocketIO

/// Protocol defining the configurable properties and methods for a socket environment.
public protocol SocketEnvironmentConfigurable {
    /// The URL path for the socket environment.
    var path: String { get }
    
    /// Creates a URL based on the environment's path.
    ///
    /// - Throws: An error of type `SocketEnvironmentError` if URL creation fails.
    /// - Returns: A URL instance.
    func makeURL() throws -> URL
    
    /// Creates a configuration for the socket client with the provided headers.
    ///
    /// - Parameter headers: The headers to be included in the configuration.
    /// - Returns: A `SocketIOClientConfiguration` instance.
    func makeConfig(with headers: [String: String]) -> SocketIOClientConfiguration
}

/// Enum representing different socket environments.
public enum SocketEnvironment: SocketEnvironmentConfigurable {
    /// The Waxpeer socket environment.
    case waxpeer
    
    private var logs: Bool {
        #if DEBUG
        return false
        #else
        return false
        #endif
    }
    
    /// The URL path for the Waxpeer socket environment.
    public var path: String {
        switch self {
        case .waxpeer:
            return "https://waxpeer.com/socket.io/?EIO=4&transport=websocket"
        }
    }
    
    /// Creates a URL for the Waxpeer socket environment.
    ///
    /// - Throws: An error of type `SocketEnvironmentError` if URL creation fails.
    /// - Returns: A URL instance.
    public func makeURL() throws -> URL {
        guard let url = URL(string: path) else {
            throw SocketEnvironmentError.urlCreationFailed
        }
        
        return url
    }
    
    /// Creates a configuration for the socket client with the provided headers.
    ///
    /// - Parameter headers: The headers to be included in the configuration.
    /// - Returns: A `SocketIOClientConfiguration` instance.
    public func makeConfig(with headers: [String: String]) -> SocketIOClientConfiguration {
        switch self {
        case .waxpeer:
            return [
                .log(logs),
                .extraHeaders(headers),
                .forceWebsockets(true),
                .forceNew(true)
            ]
        }
    }
}
