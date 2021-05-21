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
            var result: Any? = nil
            if let data = data {
                result = data
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode, let result = result {
                completion(.success(result))
            } else {
                let error = (result as? [String : Any?]).flatMap(ServiceError.init) ?? ServiceError.other
                completion(.failure(error))
            }
        }
        
        task.resume()
        return task
    }
}

// extensions

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection"
        case .other:
            return "Something went wrong"
        case .custom(let msg):
            return msg
        }
    }
}
