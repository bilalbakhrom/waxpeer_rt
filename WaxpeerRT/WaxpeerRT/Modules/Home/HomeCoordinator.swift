//
//  HomeCoordinator.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation
import AppBaseController

public final class HomeCoordinator: BaseCoordinator {
    public let deps: HomeDependency
    
    public init(_ deps: HomeDependency, navigationController: BaseNavigationController) {
        self.deps = deps
        super.init(navigationController: navigationController)
    }
    
    public override func start(animated: Bool) {
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: animated)
    }
}
