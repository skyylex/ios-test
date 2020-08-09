//
//  CallDetailsViewController.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

protocol CallDetailsViewInputs: class {
    func setHeaderTitle(_ title: String)
    func setCompactInfoDetails(phoneNumber: String, detailsText: String, timeText: String)
}

protocol CallDetailsViewOutputs {
    func viewWillAppear()
}

final class CallDetailsViewController: UIViewController, CallDetailsViewInputs {
    var output: CallDetailsViewOutputs!
    
    override func loadView() {
        view = createView()
    }
    
    override func viewDidLoad() {
        precondition(output != nil, "View Output should be set before view is loaded")
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    private var headerLabel = UILabel()
    private var compactInfoView = CallDetailsCompactInfoView()
    
    func setHeaderTitle(_ title: String) {
        precondition(isViewLoaded, "Attempt to update header too early")
        
        headerLabel.text = title
    }
    
    func setCompactInfoDetails(phoneNumber: String, detailsText: String, timeText: String) {
        precondition(isViewLoaded, "Attempt to update header too early")
        
        compactInfoView.setup(phoneNumber: phoneNumber,
                              detailsText: detailsText,
                              timeText: timeText)
    }
    
    private func createView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.blue142()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.lightGray251()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        compactInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(headerView)
        container.addSubview(bottomView)
        container.addSubview(compactInfoView)
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.4)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0),
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            compactInfoView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            compactInfoView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 50),
            compactInfoView.centerYAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
//            compactInfoView.centerYAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
        ])
        
        return container
    }
}
