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
    
    var userInfo: Any?
}

protocol ActivityFeedViewInputs: class {
    func setFeedSections(sections: [ActivityFeedSection])
}
protocol ActivityFeedViewOutputs {
    func callSelected(_ call: ActivityFeedItem)
    
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
    var isLoading: Bool = false {
        didSet {
            if (self.isLoading && tableView.tableHeaderView == nil) {
                let indicator = UIActivityIndicatorView(style: .medium)
                indicator.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
                tableView.tableHeaderView = indicator
                indicator.startAnimating()
            } else {
                tableView.tableHeaderView = nil
            }
        }
    }
    
    private var updateUIAction: (() -> Void)?
    func setFeedSections(sections: [ActivityFeedSection]) {
        precondition(Thread.isMainThread, "Main thread is required to update UI")
        
        isLoading = true
        
        // Avoid scheduling if already scheduled an update, just replace what is updated
        let shouldScheduleUpdate = updateUIAction == nil
        updateUIAction = { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            
            self.dataSource.sections = sections
            self.delegate.sectionTitles = sections.map { $0.title }
            self.delegate.forwardSelectionAction = { [weak self] indexPath in
                guard let self = self else { return }
                
                let item = sections[indexPath.section].items[indexPath.row]
                
                self.output.callSelected(item)
            }
            
            self.tableView.reloadData()
        }
        
        if (shouldScheduleUpdate) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
                guard let self = self else { return }
                if let action = self.updateUIAction {
                    action()
                }
            }
        }
    }
    
    private(set) var didAppear: Bool = false
}
