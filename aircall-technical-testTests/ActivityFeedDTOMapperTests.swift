//
//  ActivityFeedDTOMapperTests.swift
//  aircall-technical-testTests
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation
import XCTest
@testable import aircall_technical_test

final class ActivityFeedDTOMapperTests: XCTestCase {
    func testMappingForEmptyArray() {
        let mapper = ActivityFeedDTOMapper()
        XCTAssertEqual(mapper.map(dataObjects: []).count, 0)
    }
    
    func testMappingForSingleObject() {
        let map: [String:Any] = [
            "id": 1232,
            "from":"+1-543-324-321",
            "to":"+1-532-454-999",
            "via":"Rome",
            "created_at":"2018-04-19T09:38:41.000Z",
            "direction":"outbound",
            "duration":"321",
            "is_archived":false,
            "call_type":"answered"
        ]
        
        let mapper = ActivityFeedDTOMapper()
        let dataObject = createSingleCallData(with: map)
        let calls = mapper.map(dataObjects: [dataObject])
        
        XCTAssertEqual(calls.count, 1)
        
        guard let call = calls.first else { return }
        
        XCTAssertEqual(call.id, 1232)
        XCTAssertEqual(call.from, "+1-543-324-321")
        XCTAssertEqual(call.to, "+1-532-454-999")
        XCTAssertEqual(call.via, "Rome")
        XCTAssertEqual(call.direction.rawValue, "outbound")
        XCTAssertEqual(call.duration, 321)
        XCTAssertEqual(call.isArchived, false)
        XCTAssertEqual(call.type.rawValue, CallType.answered.rawValue)
    }
    
    func testMappingForMultipleDataObjects() {
        let mapper = ActivityFeedDTOMapper()
        let dataObjects = createCallDataObjects()
        let calls = mapper.map(dataObjects: dataObjects)
        
        XCTAssertEqual(calls.count, dataObjects.count)
    }
    
    // MARK: Shortcuts
    func createSingleCallData(with map: [String:Any]) -> CallDTO {
        guard let data = try? JSONSerialization.data(withJSONObject: map, options: .sortedKeys) else {
            preconditionFailure("activities.json is not found")
        }
        
        let decoder = JSONDecoder()
        guard let dataObject = try? decoder.decode(CallDTO.self, from: data) else {
            preconditionFailure("data objects cannot be created")
        }
        
        return dataObject
    }
    
    func createCallDataObjects() -> [CallDTO] {
        let bundle = Bundle(for: Self.self)
        guard let activitiesJsonURL = bundle.url(forResource: "activities", withExtension: "json") else {
            preconditionFailure("activities.json is not found")
        }
        
        guard let data = try? Data(contentsOf: activitiesJsonURL) else {
            preconditionFailure("activities.json is not found")
        }
        
        let decoder = JSONDecoder()
        guard let dataObjects = try? decoder.decode([CallDTO].self, from: data) else {
            preconditionFailure("data objects cannot be created")
        }
        
        return dataObjects
    }
}
