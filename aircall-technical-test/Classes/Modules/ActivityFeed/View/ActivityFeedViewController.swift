//
//  ActivityFeedViewController.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 07/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

struct ActivityFeedSection {
    var title: String
    var items: [ActivityFeedItem]
}

struct ActivityFeedItem {
    var phoneNumber: String
    var time: String
    var details: String
}

protocol ActivityFeedViewInputs: class {
    func setFeedSections(sections: [ActivityFeedSection])
}
protocol ActivityFeedViewOutputs {
    func callSelected(at indexPath: IndexPath)
    
    func viewDidAppear()
    func viewDidDisappear()
}

final class ActivityFeedViewController: UIViewController, ActivityFeedViewInputs {
    var output: ActivityFeedViewOutputs!
    let dataSource = ActivityFeedTableViewDataSource()
    let delegate = ActivityFeedTableViewDelegate()
    var tableView: UITableView!
    
    override func loadView() {
        view = createView()
    }
    
    override func viewDidLoad() {
        precondition(output != nil, "View Output should be set before view is loaded")
        precondition(tableView != nil, "UITableView should be already created in viewDidLoad")
        
        super.viewDidLoad()
        
        delegate.output = output
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        output.viewDidDisappear()
    }
    
    func createView() -> UIView {
        let view = UIView()
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.lightGray251()
        tableView.separatorStyle = .singleLine
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = UIColor.lightGray251()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
        ])
        
        return view
    }
    
    // MARK: ActivityFeedViewInputs
    func setFeedSections(sections: [ActivityFeedSection]) {
        dataSource.sections = sections
        delegate.sectionTitles = sections.map { $0.title }
        
        tableView.reloadData()
    }
    
    private(set) var didAppear: Bool = false
}
