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
    func loadingStarted()
    func setFeedSections(sections: [ActivityFeedSection])
    func setPullControlTitle(title: NSAttributedString)
}

protocol ActivityFeedViewOutputs {
    func callSelected(_ call: ActivityFeedItem)
    func requestUpdate()
    
    func viewWillAppear()
    func viewDidAppear()
    func viewDidDisappear()
}

final class ActivityFeedViewController: UIViewController, ActivityFeedViewInputs {
    var output: ActivityFeedViewOutputs!
    
    private let dataSource = ActivityFeedTableViewDataSource()
    private let delegate = ActivityFeedTableViewDelegate()
    private var tableView: UITableView!
    private var scheduledUpdateUIAction: (() -> Void)?
    
    override func loadView() {
        view = UIView()
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.lightGray251()
        tableView.separatorStyle = .singleLine
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        
        refreshControl.addTarget(self,
                                 action: #selector(requestUpdate),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.backgroundColor = UIColor.lightGray251()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
        ])
    }
    
    override func viewDidLoad() {
        precondition(output != nil, "View Output should be set before view is loaded")
        precondition(tableView != nil, "UITableView should be already created in viewDidLoad")
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        output.viewDidDisappear()
    }
    
    // MARK: Private
    
    @objc func requestUpdate() {
        output.requestUpdate()
    }
    
    private var refreshControl = UIRefreshControl()
    
    private var isLoading: Bool = false {
        didSet {
            if self.isLoading && !refreshControl.isRefreshing {
                let indicator = createLoadingIndicator()
                tableView.tableHeaderView = indicator
                
                indicator.startAnimating()
            } else {
                tableView.tableHeaderView = nil
            }
        }
    }
    
    private func createLoadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        return indicator
    }
    
    // MARK: ActivityFeedViewInputs
    
    func setFeedSections(sections: [ActivityFeedSection]) {
        precondition(Thread.isMainThread, "Main thread is required to update UI")
        
        isLoading = true
        
        scheduledUpdateUIAction = { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            
            self.dataSource.sections = sections
            self.delegate.sectionTitles = sections.map { $0.title }
            self.delegate.selectionAction = { [weak self] indexPath in
                guard let self = self else { return }
                
                let item = sections[indexPath.section].items[indexPath.row]
                
                self.output.callSelected(item)
            }
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.3) { [weak self] in
            guard let self = self else { return }
            
            if let action = self.scheduledUpdateUIAction {
                action()
            }
        }
    }
    
    func setPullControlTitle(title: NSAttributedString) {
        refreshControl.attributedTitle = title
    }
    
    func loadingStarted() {
        isLoading = true
    }
}
