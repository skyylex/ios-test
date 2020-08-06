//
//  ActivityFeedViewController.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 07/08/2020.
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
        
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.text = "+1 347-318-0395"
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        let detailsLabel = UILabel()
        detailsLabel.text = "missed call"
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 13)
        detailsLabel.textColor = UIColor.gray184()
        
        let timeLabel = UILabel()
        timeLabel.text = "12:18 PM"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.boldSystemFont(ofSize: 13)
        timeLabel.textColor = UIColor.gray184()
        
        cell.contentView.backgroundColor = UIColor.almostWhite254()
        cell.backgroundColor = UIColor.clear
        
        cell.contentView.addSubview(phoneNumberLabel)
        cell.contentView.addSubview(detailsLabel)
        cell.contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            phoneNumberLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor,
                                                      constant: 40),
            phoneNumberLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor,
                                                  constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: phoneNumberLabel.leadingAnchor,
                                                 constant: 0),
            detailsLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor,
                                             constant: 0),
            detailsLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor,
                                                constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor,
                                           constant: -40),
        ])
        
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
        
        let dateLabel = UILabel()
        dateLabel.text = "Today"
        dateLabel.textColor = UIColor.gray184()
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor, constant: 0),
            header.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 0),
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
        tableView.separatorStyle = .none
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        
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
