//
//  BaseCoordinator.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import UIKit

open class BaseCoordinator: Coordinator {
    public var navigationController: BaseNavigationController
    
    public init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    open func start(animated: Bool) {
        fatalError("Override this method")
    }
    
    public func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
