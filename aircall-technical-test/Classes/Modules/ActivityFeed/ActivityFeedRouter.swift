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
    func showCallDetails(call: CallDetails)
}

final class ActivityFeedRouter: ActivityFeedRouterInputs {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ActivityFeedViewController()
        let interactor = ActivityFeedInteractor()
        let presenter = ActivityFeedPresenter(view: viewController, router: self, output: interactor)
        
        viewController.output = presenter
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    // MARK: ActivityFeedRouterInputs
    
    func showCallDetails(call: CallDetails) {
        let router = CallDetailsRouter(navigationController: self.navigationController)
        router.start(call: call)
    }
}
