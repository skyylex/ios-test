//
//  CallDetailsPresenter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

protocol CallDetailsPresenterOutputs {
    var call: CallDetails { get }
}
protocol CallDetailsPresenterInputs {}

final class CallDetailsPresenter: CallDetailsPresenterInputs, CallDetailsViewOutputs {
    weak var view: CallDetailsViewInputs?
    let router: CallDetailsRouterInputs
    let output: CallDetailsPresenterOutputs
    
    init(view: CallDetailsViewInputs,
         router: CallDetailsRouterInputs,
         output: CallDetailsPresenterOutputs) {
        self.view = view
        self.router = router
        self.output = output
    }
}
