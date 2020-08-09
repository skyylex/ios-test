//
//  CallDetails.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

enum Direction: String {
    case inbound = "inbound"
    case outbound = "outbound"
}

enum CallType: String {
    case missed = "missed"
    case answered = "answered"
    case voicemail = "voicemail"
}

/// Represents call details with more strict type system
struct CallDetails {
    
    let id: Int
    let creationDate: Date
    let direction: Direction
    let from: String
    let to: String?
    let via: String
    let duration: Int
    var isArchived: Bool
    let type: CallType
}
