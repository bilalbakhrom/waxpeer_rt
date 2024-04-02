//
//  SocketEnvironmentConfigurable.swift
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
