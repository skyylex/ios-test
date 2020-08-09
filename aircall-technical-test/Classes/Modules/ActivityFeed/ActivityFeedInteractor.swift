//
//  ActivityFeedInteractor.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

final class ActivityFeedInteractor: ActivityFeedPresenterOutputs {
    let networkService: NetworkService
    let mapper = ActivityFeedDTOMapper()
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = NetworkService()
    }
    
    func fetchActivityFeed(completion: @escaping (Result<[CallDetails], Error>) -> Void) {
        networkService.fetchActivityFeed { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let jsonObjects):
                let calls = self.mapper.map(dataObjects: jsonObjects)
                completion(.success(calls))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

final class ActivityFeedDTOMapper {
    // Recognizes the following format: 2018-04-18T16:53:22.000Z
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return formatter
    }()
    
    func map(dataObjects: [CallDTO]) -> [CallDetails] {
        return dataObjects.map { dataObject -> CallDetails? in
            guard let direction = Direction(rawValue: dataObject.direction) else { return nil }
            guard let type = CallType(rawValue: dataObject.type) else { return nil }
            guard let duration = Int(dataObject.duration) else { return nil }
            guard let date = formatter.date(from: dataObject.creationDate) else { return nil }
            
            return CallDetails(
                id: dataObject.id,
                creationDate: date,
                direction: direction,
                from: dataObject.from,
                to: dataObject.to,
                via: dataObject.via,
                duration: duration,
                isArchived: dataObject.isArchived,
                type: type
            )
        }.compactMap { $0 }
    }
}
