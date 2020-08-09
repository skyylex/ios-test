//
//  ActivityFeedTableViewDataSource.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

extension ActivityFeedCell.Position {
    static func position(from row: Int, numberOfItems: Int) -> ActivityFeedCell.Position {
        if row == 0 && numberOfItems == 1 {
            return .single
        } else if row == 0 {
            return .top
        } else if row == numberOfItems - 1 {
            return .bottom
        } else  {
            return .middle
        }
    }
}

class ActivityFeedTableViewDataSource: NSObject, UITableViewDataSource {
    var sections = [ActivityFeedSection]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActivityFeedCell()
        let position = ActivityFeedCell.Position.position(
            from: indexPath.row,
            numberOfItems: numberOfItems(in: indexPath.section)
        )
        cell.setup(position: position, cellModel: cellModel(for: indexPath))
        return cell
    }
    
    // MARK: Shortcut
    
    func cellModel(for indexPath: IndexPath) -> ActivityFeedItem {
        return self.sections[indexPath.section].items[indexPath.row]
    }
    
    func numberOfItems(in section: Int) -> Int {
        return self.sections[section].items.count
    }
    
}

