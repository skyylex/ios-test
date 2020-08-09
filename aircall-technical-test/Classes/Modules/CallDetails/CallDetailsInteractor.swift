//
//  CallDetailsInteractor.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

final class CallDetailsInteractor: CallDetailsPresenterOutputs {
    let call: CallDetails
    init(call: CallDetails) {
        self.call = call
    }
}
