//
//  WaxpeerSocketManager.swift
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
}

/// A class managing WebSocket connections for the Waxpeer platform.
public final class WaxpeerSocketManager: WebSocketProtocol {
    private let manager: SocketManager
    private let socket: SocketIOClient
    private var itemEvents: [WaxpeerGameItemEvent]
    private var gameEvents: [WaxpeerGameEvent]
    private let apiKey = "f414c0250af5745dfa14acd5b22e5361ebf810f00e9c3a77d307270b75d8daed"
    
    /// The delegate for receiving Waxpeer socket events.
    public weak var delegate: WaxpeerSocketDelegate?
    
    /// Initializes the WaxpeerSocketManager with the given environment and optional initial events.
    ///
    /// - Parameters:
    ///   - env: The environment for the socket connection.
    ///   - gameEvents: The initial game events to subscribe to.
    ///   - itemEvents: The initial item events to register for.
    public init?(
        env: SocketEnvironment,
        gameEvents: [WaxpeerGameEvent] = WaxpeerGameEvent.allCases,
        itemEvents: [WaxpeerGameItemEvent] = WaxpeerGameItemEvent.allCases
    ) {
        guard let socketURL = try? env.makeURL() else { return nil }
                
        let socketManager = SocketManager(
            socketURL: socketURL,
            config: env.makeConfig(with: ["Authorization": apiKey])
        )
        
        self.socket = socketManager.defaultSocket
        self.manager = socketManager
        self.gameEvents = gameEvents
        self.itemEvents = itemEvents
    }
    
    // MARK: - WebSocketProtocol
    
    public func connect() {
        addHandlers()
        socket.connect()
    }
    
    public func disconnect() {
        socket.removeAllHandlers()
        socket.disconnect()
    }
    
    // MARK: - Events
    
    /// Subscribes to the specified game events.
    ///
    /// - Parameter events: The game events to subscribe to.
    public func subscribe(to events: [WaxpeerGameEvent]) {
        let eventsToUnsubscribe = gameEvents.filter { !events.contains($0) }
        unsubscribe(from: eventsToUnsubscribe)
        gameEvents = events
        events.forEach { socket.emit("subscribe", ["name": $0.rawValue]) }
    }
    
    /// Unsubscribes from the specified game events.
    ///
    /// - Parameter events: The game events to unsubscribe from.
    public func unsubscribe(from events: [WaxpeerGameEvent]) {
        events.forEach { event in
            if let index = gameEvents.firstIndex(of: event) {
                gameEvents.remove(at: index)
            }
        }
        
        events.forEach { socket.emit("unsubscribe", ["name": $0.rawValue]) }
    }
    
    /// Registers for the specified item events.
    ///
    /// - Parameter events: The item events to register for.
    public func register(for events: [WaxpeerGameItemEvent]) {
        socket.removeAllHandlers()
        itemEvents = events
        
        events.forEach { event in
            socket.on(event.rawValue) { [weak self] data, ack in
                guard let self else { return }
                Task { await self.handleItemEvent(event, data: data, ack: ack) }
            }
        }
    }
    
    /// Deregisters from the specified item events.
    ///
    /// - Parameter events: The item events to deregister from.
    public func deregister(from events: [WaxpeerGameItemEvent]) {
        socket.removeAllHandlers()
        
        events.forEach { event in
            if let index = itemEvents.firstIndex(of: event) {
                itemEvents.remove(at: index)
            }
        }
        
        register(for: itemEvents)
    }
    
    // MARK: - Actions
    
    private func handleConnect(_ data: [Any], _ ack: SocketAckEmitter) async {
        subscribe(to: gameEvents)
        register(for: itemEvents)
        await delegate?.waxpeerSocketDidConnect(self)
    }
    
    private func handleDisconnect(_ data: [Any], _ ack: SocketAckEmitter) async {
        await delegate?.waxpeerSocketDidDisconnect(self)
    }
    
    private func handleItemEvent(_ event: WaxpeerGameItemEvent, data: [Any], ack: SocketAckEmitter) async {
        do {
            let item = try decode(GameItem.self, from: data)
            await delegate?.waxpeerSocket(self, didReceiveGameItem: item, event: event)
        } catch {
            print("[ERROR new] \(error)")
        }
    }
    
    // MARK: - Helpers
    
    private func addHandlers() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self else { return }
            Task { await self.handleConnect(data, ack) }
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            guard let self else { return }
            Task { await self.handleDisconnect(data, ack) }
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: [Any]) throws -> T {
        guard let jsonData = (data as? [[String: Any]])?.first else {
            throw JSONParsingError.invalidDataFormat
        }
        
        // Convert JSON dictionary to Data
        let data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
        // Decode JSON data.
        return try JSONDecoder().decode(type, from: data)
    }
}
