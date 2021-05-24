//
//  APIClient.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 4/24/21.
//

import Foundation
import Reachability

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

final class APIClient {
    private var baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func load(path: String, method: RequestMethod, params: [String: String], completion: @escaping (Result<Any, ServiceError>) -> Void) -> URLSessionDataTask? {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            completion(.failure(.noInternetConnection))
        }
        
        let request = URLRequest(baseURL: self.baseURL, path: path, method: method, params: params)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard (error as NSError?)?.code != NSURLErrorCancelled else {
                return
            }
            
            var result: Any? = nil
            if let data = data {
                result = data
            }
            
            if error != nil {
                let serviceError = ServiceError(info: ["message": error?.localizedDescription])
                completion(.failure(serviceError))
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode, let result = result {
                completion(.success(result))
            }
        }
        
        task.resume()
        return task
    }
}
