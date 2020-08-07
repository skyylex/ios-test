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

protocol ActivityFeedViewInputs { }
protocol ActivityFeedViewOutputs {
    func callSelected(at indexPath: IndexPath)
}

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

class ActivityFeedTableViewDelegate: NSObject, UITableViewDelegate {
    var output: ActivityFeedViewOutputs!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.callSelected(at: indexPath)
    }
    
}

final class ActivityFeedViewController: UIViewController, ActivityFeedViewInputs {
    var output: ActivityFeedViewOutputs!
    let dataSource = ActivityFeedTableViewDataSource()
    let delegate = ActivityFeedTableViewDelegate()
    
    override func loadView() {
        view = createView()
    }
    
    override func viewDidLoad() {
        precondition(output != nil, "View Output should be set before view is loaded")
        
        super.viewDidLoad()
        
        delegate.output = output
    }
    
    func createView() -> UIView {
        let view = UIView()
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        
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
