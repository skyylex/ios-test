//
//  File.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

final class NavigationControllerProxy: NavigationController {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController,
                                                animated: animated)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        navigationController.setViewControllers(viewControllers,
                                                animated: animated)
    }
}
