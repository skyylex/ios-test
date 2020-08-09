//
//  NetworkService.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 09/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

final class NetworkRequestBuilder {
    let allActivitiesURLString: String = "https://aircall-job.herokuapp.com/activities"
    
    func buildAllActivitiesRequest() -> URLRequest? {
        guard let url = URL(string: allActivitiesURLString) else { return nil }
        
        return URLRequest(url: url)
    }
}

final class NetworkService {
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
