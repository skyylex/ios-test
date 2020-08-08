//
//  ActivityFeedCell.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

private extension UILabel {
    func heightConstraint(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
        return constraint
    }
}

final class ActivityFeedCell: UITableViewCell {
    enum Position {
        case top
        case middle
        case bottom
    }
    
    func setup(position: Position) {
        let phoneNumberLabel = createPhoneNumberLabel()
        let detailsLabel = createDetailsLabel()
        let timeLabel = createTimeLabel()
        
        setupStyle(position: position)
        
        [phoneNumberLabel, detailsLabel, timeLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate(phoneNumberLabelConstraints(with: phoneNumberLabel))
        NSLayoutConstraint.activate(timeLabelConstraints(with: timeLabel))
        NSLayoutConstraint.activate(detailsLabelConstraints(with: detailsLabel,
                                                            phoneNumberLabel: phoneNumberLabel))
    }
    
    func setupStyle(position: Position) {
        backgroundColor = UIColor.lightGray251()
        contentView.backgroundColor = UIColor.white
        selectionStyle = .none
        
        switch position {
        case .top:
            contentView.layer.cornerRadius = 20.0
            contentView.layer.maskedCorners = .init([.layerMinXMinYCorner])
        case .bottom:
            contentView.layer.cornerRadius = 20.0
            contentView.layer.maskedCorners = .init([.layerMinXMaxYCorner])
        case .middle:
            break;
        }
    }
    
    // MARK: Labels
    
    func createPhoneNumberLabel() -> UILabel {
        let label = UILabel()
        label.text = "+1 347-318-0395"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }
    
    func createTimeLabel() -> UILabel {
        let label = UILabel()
        label.text = "12:18 PM"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.gray184()
        return label
    }
    
    func createDetailsLabel() -> UILabel {
        let detailsLabel = UILabel()
        detailsLabel.text = "missed call"
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 13)
        detailsLabel.textColor = UIColor.gray184()
        return detailsLabel
    }
    
    // MARK: Constraints
    
    func phoneNumberLabelConstraints(with phoneNumberLabel: UILabel) -> [NSLayoutConstraint] {
        return [
            phoneNumberLabel.heightConstraint(constant: 20),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: 40),
            phoneNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                  constant: 10),
        ]
    }
    
    func detailsLabelConstraints(with detailsLabel: UILabel,
                                 phoneNumberLabel: UILabel) -> [NSLayoutConstraint] {
        return [
            detailsLabel.heightConstraint(constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: phoneNumberLabel.leadingAnchor, constant: 0),
            detailsLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 0),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ]
    }
    
    func timeLabelConstraints(with timeLabel: UILabel) -> [NSLayoutConstraint] {
        return [
            timeLabel.heightConstraint(constant: 20),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
        ]
    }
}
