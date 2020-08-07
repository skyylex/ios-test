//
//  ActivityFeedRouter.swift
//  aircall-technical-test
//
//  Created by Anna Lapitskaya on 07/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

final class ActivityFeedRouter {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewController = ActivityFeedViewController()
        let presenter = ActivityFeedPresenter(view: viewController)
        
        viewController.output = presenter
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}

final class ActivityFeedPresenter: ActivityFeedViewOutputs {
    let view: ActivityFeedViewInputs
    
    init(view: ActivityFeedViewInputs) {
        self.view = view
    }
}

protocol ActivityFeedViewInputs { }
protocol ActivityFeedViewOutputs { }

final class ActivityFeedViewController: UIViewController, ActivityFeedViewInputs {
    var output: ActivityFeedViewOutputs!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
    }
}
