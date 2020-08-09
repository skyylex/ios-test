//
//  ActivityFeedInteractor.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

class NetworkRequestBuilder {
    let allActivitiesURLString: String = "https://aircall-job.herokuapp.com/activities"
    
    func buildAllActivitiesRequest() -> URLRequest? {
        guard let url = URL(string: allActivitiesURLString) else { return nil }
        
        return URLRequest(url: url)
    }
}

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

class NetworkService {
    private let requestBuilder: NetworkRequestBuilder
    
    init(requestBuilder: NetworkRequestBuilder = NetworkRequestBuilder()) {
        self.requestBuilder = requestBuilder
    }
    
    func fetchActivityFeed(completion: @escaping (Result<[CallDTO], Error>) -> Void) {
        guard let request = requestBuilder.buildAllActivitiesRequest() else {
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkServiceError", code: 100, userInfo: [
                    NSLocalizedDescriptionKey : "No data provided in the response"
                ])
                completion(.failure(error))
                return
            }
            
            let decoder = JSONDecoder()
            if let calls = try? decoder.decode([CallDTO].self, from: data) {
                completion(.success(calls))
            }
            else {
                let error = NSError(domain: "NetworkServiceError", code: 100, userInfo: [
                    NSLocalizedDescriptionKey : "Data provided in unsupported format"
                ])
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}



final class ActivityFeedInteractor: ActivityFeedPresenterOutputs {
    let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = NetworkService()
    }
    
    func fetchActivityFeed(completion: @escaping (Result<[CallDetails], Error>) -> Void) {
        networkService.fetchActivityFeed { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let jsonObjects):
                let calls = self.map(dataObjects: jsonObjects)
                completion(.success(calls))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

extension ActivityFeedInteractor {
    func map(dataObjects: [CallDTO]) -> [CallDetails] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        // 2018-04-18T16:53:22.000Z 2020-08-09T09:56:55+0000
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
