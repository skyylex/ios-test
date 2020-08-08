//
//  ActivityFeedViewController.swift
//  aircall-technical-test
//
//  Created by Anna Lapitskaya on 07/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityFeedViewInputs { }
protocol ActivityFeedViewOutputs {
    func callSelected(at indexPath: IndexPath)
}

class ActivityFeedTableViewDataSource: NSObject, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.backgroundColor = UIColor.almostWhite254()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
}

class ActivityFeedTableViewDelegate: NSObject, UITableViewDelegate {
    var output: ActivityFeedViewOutputs!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.callSelected(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.lightGray252()
        
        let label = UILabel()
        label.text = "Today"
        label.textColor = UIColor.gray184()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(label)
        
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: label.centerXAnchor, constant: 0),
            header.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0),
        ])
        
        return header
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
        tableView.backgroundColor = UIColor.lightGray252()
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        
        view.backgroundColor = UIColor.lightGray252()
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
