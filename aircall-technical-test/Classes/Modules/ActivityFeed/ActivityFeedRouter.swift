//
//  ActivityFeedRouter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 07/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityFeedRouterInputs {
    func showCallDetails()
}

final class ActivityFeedRouter: ActivityFeedRouterInputs {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewController = ActivityFeedViewController()
        let presenter = ActivityFeedPresenter(view: viewController, router: self)
        
        viewController.output = presenter
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    // MARK: ActivityFeedRouterInputs
    
    func showCallDetails() {
        // TODO: add proper support for Call Details
        navigationController.pushViewController(UIViewController(), animated: true)
    }
}

final class ActivityFeedPresenter: ActivityFeedViewOutputs {
    let view: ActivityFeedViewInputs
    let router: ActivityFeedRouterInputs
    
    init(view: ActivityFeedViewInputs, router: ActivityFeedRouterInputs) {
        self.view = view
        self.router = router
    }
    
    // MARK: ActivityFeedViewOutputs
    func callSelected(at indexPath: IndexPath) {
        // TODO: provide real call object
        router.showCallDetails()
    }
}
