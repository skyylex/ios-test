//
//  ActivityFeedTableViewDelegate.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

final class ActivityFeedTableViewDelegate: NSObject, UITableViewDelegate {
    var sectionTitles = [String]()
    var forwardSelectionAction: (IndexPath) -> Void = { _ in }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        forwardSelectionAction(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.lightGray251()
        
        let dateLabel = UILabel()
        dateLabel.text = sectionTitles[section]
        dateLabel.textColor = UIColor.gray184()
        dateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor, constant: 0),
            header.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor, constant: 0),
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
