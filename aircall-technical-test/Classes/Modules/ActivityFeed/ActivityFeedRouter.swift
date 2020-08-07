//
//  ActivityFeedRouter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 07/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityFeedRouterInputs {}

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
}

final class ActivityFeedPresenter: ActivityFeedViewOutputs {
    let view: ActivityFeedViewInputs
    let router: ActivityFeedRouterInputs
    
    init(view: ActivityFeedViewInputs, router: ActivityFeedRouterInputs) {
        self.view = view
        self.router = router
    }
}

protocol ActivityFeedViewInputs { }
protocol ActivityFeedViewOutputs { }

class ActivityFeedTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}

final class ActivityFeedViewController: UIViewController, ActivityFeedViewInputs {
    var output: ActivityFeedViewOutputs!
    let dataSource = ActivityFeedTableViewDataSource()
    
    override func loadView() {
        view = createView()
    }
    
    func createView() -> UIView {
        let view = UIView()
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
        ])
        
        return view
    }
}
