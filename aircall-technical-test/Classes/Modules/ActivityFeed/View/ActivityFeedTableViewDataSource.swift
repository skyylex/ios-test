//
//  ActivityFeedTableViewDataSource.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

class ActivityFeedTableViewDataSource: NSObject, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActivityFeedCell()
        cell.setup(position: position(from: indexPath.row, numberOfItems: 3))
        return cell
    }
    
    func position(from row: Int, numberOfItems: Int) -> ActivityFeedCell.Position {
        if row == 0 {
            return .top
        } else if row == numberOfItems - 1 {
            return .bottom
        } else  {
            return .middle
        }
    }
    
}

