//
//  CallDetailsRouterTests.swift
//  aircall-technical-testTests
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import XCTest
@testable import aircall_technical_test

final class CallDetailsRouterTests: XCTestCase {
    func testStart() {
        let navigationController = NavigationControllerMock()
        let router = CallDetailsRouter(navigationController: navigationController)
        router.start(call: createCallDetails())
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    private func createCallDetails() -> CallDetails {
        return CallDetails(
            id: 0,
            creationDate: Date(),
            direction: Direction.inbound,
            from: "+1-612-324-123",
            to: "+1-612-324-123",
            via: "NY office",
            duration: 23,
            isArchived: true,
            type: .missed
        )
    }
    
}
