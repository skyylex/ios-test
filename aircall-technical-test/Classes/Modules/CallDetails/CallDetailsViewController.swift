//
//  CallDetailsViewController.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import UIKit

protocol CallDetailsViewInputs: class {}
protocol CallDetailsViewOutputs {}

final class CallDetailsViewController: UIViewController, CallDetailsViewInputs {
    var output: CallDetailsViewOutputs!
    
    override func loadView() {
        view = createView()
    }
    
    override func viewDidLoad() {
        precondition(output != nil, "View Output should be set before view is loaded")
        
        super.viewDidLoad()
    }
    
    func createView() -> UIView {
        return UIView()
    }
}
