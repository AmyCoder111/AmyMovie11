//
//  Utils.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 4/25/21.
//

import Foundation

extension URL {
    init(baseUrl: String, path: String, params: [String: String], method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        
        components.path += path
        
        switch method {
        case .get:
            let queryItems: [URLQueryItem] = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            components.queryItems = queryItems
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    init(baseURL: String, path: String, method: RequestMethod, params: [String : String]) {
        let url = URL(baseUrl: baseURL, path: path, params: params, method: method)
        
        self.init(url: url)
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch method {
            case .post, .put:
                do {
                    httpBody = try JSONSerialization.data(withJSONObject: params, options: []) //add parameters to the request body
                } catch {
                    
                }
            default:
                break
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
