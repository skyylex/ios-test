//
//  aircall_technical_testTests.swift
//  aircall-technical-testTests
//
//  Created by Yury Lapitsky on 06/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import XCTest
@testable import aircall_technical_test

final class NavigationControllerMock: NavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllers = viewControllers + [viewController]
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        self.viewControllers = viewControllers
    }
    
    var viewControllers = [UIViewController]()
    
}

final class ActivityFeedRouteTests: XCTestCase {
    func testStart() {
        let navigationController = NavigationControllerMock()
        let router = ActivityFeedRouter(navigationController: navigationController)
        router.start()
        
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    func testShowCallDetails() {
        UIView.setAnimationsEnabled(false)
        
        let navigationController = NavigationControllerMock()
        let router = ActivityFeedRouter(navigationController: navigationController)
        router.start()
        
        // Moves to Call Details screen
        router.showCallDetails(call: createCallDetails())
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
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
