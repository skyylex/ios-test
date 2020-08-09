//
//  CallDetailsRouter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

protocol CallDetailsRouterInputs {}

final class CallDetailsRouter: CallDetailsRouterInputs {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(call: CallDetails) {
        let interactor = CallDetailsInteractor(call: call)
        let viewController = CallDetailsViewController()
        let presenter = CallDetailsPresenter(
            view: viewController,
            router: self,
            output: interactor
        )
        
        viewController.output = presenter
        
        navigationController.pushViewController(viewController,
                                                animated: true)
    }
}
