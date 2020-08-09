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

final class CallDetailsPresenter: CallDetailsViewOutputs {
    
    private var timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter
    }()
    
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
    
    func viewWillAppear() {
        let call = output.call
        let title = (call.direction == .inbound) ? call.from : call.to ?? ""
        let timeText = timeFormatter.string(from: call.creationDate)
        
        view?.setHeaderTitle(title)
        view?.setCompactInfoDetails(phoneNumber: title,
                                    detailsText: call.type.rawValue,
                                    timeText: timeText)
    }
}
