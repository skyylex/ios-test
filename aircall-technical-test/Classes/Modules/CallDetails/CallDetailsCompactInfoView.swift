//
//  CallDetailsCompactInfoView.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

class CallDetailsCompactInfoView: UIView {
    func setup(phoneNumber: String, detailsText: String, timeText: String) {
        let phoneNumberLabel = createPhoneNumberLabel(phoneNumber: phoneNumber)
        let detailsLabel = createDetailsLabel(details: detailsText)
        let timeLabel = createTimeLabel(time: timeText)
        
        setupStyle()
        
        [phoneNumberLabel, detailsLabel, timeLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate(phoneNumberLabelConstraints(with: phoneNumberLabel))
        NSLayoutConstraint.activate(timeLabelConstraints(with: timeLabel))
        NSLayoutConstraint.activate(detailsLabelConstraints(with: detailsLabel,
                                                            phoneNumberLabel: phoneNumberLabel))
    }
    
    func setupStyle() {
        backgroundColor = UIColor.lightGray251()
        
        layer.borderColor = UIColor.lightGray235().cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 20.0
        layer.maskedCorners = .init([.layerMinXMaxYCorner, .layerMinXMinYCorner])
    }
    
    // MARK: Labels
    
    func createPhoneNumberLabel(phoneNumber: String) -> UILabel {
        let label = UILabel()
        label.text = phoneNumber
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }
    
    func createTimeLabel(time: String) -> UILabel {
        let label = UILabel()
        label.text = time
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.gray184()
        return label
    }
    
    func createDetailsLabel(details: String) -> UILabel {
        let detailsLabel = UILabel()
        detailsLabel.text = details
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 13)
        detailsLabel.textColor = UIColor.gray184()
        return detailsLabel
    }
    
    // MARK: Constraints
    
    func phoneNumberLabelConstraints(with phoneNumberLabel: UILabel) -> [NSLayoutConstraint] {
        return [
            phoneNumberLabel.nonRequiredHeightConstraint(constant: 20),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: 40),
            phoneNumberLabel.topAnchor.constraint(equalTo: topAnchor,
                                                  constant: 10),
        ]
    }
    
    func detailsLabelConstraints(with detailsLabel: UILabel,
                                 phoneNumberLabel: UILabel) -> [NSLayoutConstraint] {
        return [
            detailsLabel.nonRequiredHeightConstraint(constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: phoneNumberLabel.leadingAnchor, constant: 0),
            detailsLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 0),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                 constant: -10),
        ]
    }
    
    func timeLabelConstraints(with timeLabel: UILabel) -> [NSLayoutConstraint] {
        return [
            timeLabel.nonRequiredHeightConstraint(constant: 20),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                               constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -40),
        ]
    }
}
