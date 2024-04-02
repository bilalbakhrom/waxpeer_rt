//
//  WaxpeerSocketManager.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import SocketIO

/// A class managing WebSocket connections for the Waxpeer platform.
public final class WaxpeerSocketManager: WebSocketProtocol {
    private let manager: SocketManager
    private let socket: SocketIOClient
    private var itemEvents: [WaxpeerGameItemEvent]
    private var gameEvents: [WaxpeerGameEvent]
    public private(set) var isConnected: Bool = false
    
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
        
        let authKey = Bundle.module.socketKey ?? ""
        let socketManager = SocketManager(
            socketURL: socketURL,
            config: env.makeConfig(with: ["Authorization": authKey])
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
        socket.disconnect()
    }
    
    // MARK: - Events
    
    private func subscribe() {
        gameEvents.forEach { socket.emit("subscribe", ["name": $0.rawValue]) }
    }
    
    /// Subscribes to the specified game events.
    ///
    /// - Parameter events: The game events to subscribe to.
    public func subscribe(to events: [WaxpeerGameEvent]) {
        guard isConnected else { return }
        
        // Unsubscribe from old events.
        let eventsToUnsubscribe = gameEvents.filter { !events.contains($0) }
        unsubscribe(from: eventsToUnsubscribe)
        
        // Prevent duplicate by getting a new events only.
        let newEvents = events.filter { !gameEvents.contains($0) }
        
        // Update events.
        gameEvents = events
        
        // Subscribe to new events.
        newEvents.forEach { socket.emit("subscribe", ["name": $0.rawValue]) }
    }
    
    /// Unsubscribes from the specified game events.
    ///
    /// - Parameter events: The game events to unsubscribe from.
    public func unsubscribe(from events: [WaxpeerGameEvent]) {
        guard isConnected else { return }
        
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
        addHandlers()
        itemEvents = events
        
        itemEvents.forEach { event in
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
        isConnected = true
        register(for: itemEvents)
        subscribe()
        await delegate?.waxpeerSocketDidConnect(self)
    }
    
    private func handleDisconnect(_ data: [Any], _ ack: SocketAckEmitter) async {
        isConnected = false
        socket.removeAllHandlers()
        await delegate?.waxpeerSocketDidDisconnect(self)
    }
    
    private func handleStatusChange(_ data: [Any], _ ack: SocketAckEmitter) async {
        guard let socketStatus = data.first as? SocketIOStatus,
              let status = SocketConnectionStatus(socketStatus)
        else { return }
        
        await delegate?.waxpeeerSocket(self, didUpdateStatus: status)
    }
    
    private func handleItemEvent(_ event: WaxpeerGameItemEvent, data: [Any], ack: SocketAckEmitter) async {
        do {
            var item = try decode(GameItem.self, from: data)
            item.updateEvent(event)
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
        
        socket.on(clientEvent: .statusChange) { [weak self] data, ack in
            guard let self else { return }
            Task { await self.handleStatusChange(data, ack) }
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
