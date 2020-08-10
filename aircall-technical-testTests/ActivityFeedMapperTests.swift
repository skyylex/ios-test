//
//  File.swift
//  aircall-technical-testTests
//
//  Created by Yury Lapitsky on 10/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import XCTest
@testable import aircall_technical_test

final class ActivityFeedMapperTests: XCTestCase {
    func testTwoSectionsGeneration() {
        let mapper = ActivityFeedMapper()
        let todayCall = createTodayCall()
        let yesterdayCall = createTheDayBeforeCall(referenceDate: todayCall.creationDate)
        
        let sections = mapper.map(calls: [todayCall, yesterdayCall])
        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].title, "TODAY")
        XCTAssertEqual(sections[1].title, "YESTERDAY")
    }
    
    // MARK: Shortcuts
    private func createTheDayBeforeCall(referenceDate: Date) -> CallDetails {
        let yesterdaySeconds = referenceDate.timeIntervalSince1970 - (3600 * 24)
        let yesterdayDate = Date(timeIntervalSince1970: yesterdaySeconds)
        return CallDetails(
            id: 123,
            creationDate: yesterdayDate,
            direction: .inbound,
            from: "+31-623000000",
            to: "+31-6252400000",
            via: "Milan",
            duration: 50,
            isArchived: false,
            type: .answered
        )
    }
    
    private func createTodayCall() -> CallDetails {
        return CallDetails(
            id: 123,
            creationDate: Date(),
            direction: .inbound,
            from: "+31-623000000",
            to: "+31-6252400000",
            via: "Milan",
            duration: 50,
            isArchived: false,
            type: .answered
        )
    }
}
