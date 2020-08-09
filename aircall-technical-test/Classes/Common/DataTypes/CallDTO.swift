//
//  CallDTO.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

/// Represents call details as data transfer object (DTO) by direct conversion from JSON
struct CallDTO: Decodable {
    var id: Int
    var creationDate: String
    var direction: String
    var from: String
    var to: String?
    var via: String
    var duration: String
    var isArchived: Bool
    var type: String
    
    private enum CodingKeys: CodingKey {
        case id, from, to, via, created_at, direction, duration, is_archived, call_type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        creationDate = try container.decode(String.self, forKey: .created_at)
        direction = try container.decode(String.self, forKey: .direction)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String?.self, forKey: .to)
        via = try container.decode(String.self, forKey: .via)
        duration = try container.decode(String.self, forKey: .duration)
        isArchived = try container.decode(Bool.self, forKey: .is_archived)
        type = try container.decode(String.self, forKey: .call_type)
    }
}
