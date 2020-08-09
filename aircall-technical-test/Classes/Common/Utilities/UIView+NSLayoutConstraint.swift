//
//  UIView+NSLayoutConstraint.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import UIKit

extension UIView {
    func nonRequiredHeightConstraint(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
        return constraint
    }
}
