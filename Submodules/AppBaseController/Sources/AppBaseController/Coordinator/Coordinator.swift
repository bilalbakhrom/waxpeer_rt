//
//  Coordinator.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

public protocol Coordinator: AnyObject {
    /// The Coordinator takes control and activates itself.
    /// - Parameters:
    /// - animated: Set the value to true to animate the transition. Pass false if you are setting up a navigation controller before its view is displayed.
    func start(animated: Bool)
    
    /// Navigates to specified coordinator.
    /// - Parameter coordinator: The coordinator of destination screen.
    func coordinate(to coordinator: Coordinator, animated: Bool)
}

extension Coordinator {
    public func coordinate(to coordinator: Coordinator, animated: Bool = true) {
        coordinator.start(animated: true)
    }
}
