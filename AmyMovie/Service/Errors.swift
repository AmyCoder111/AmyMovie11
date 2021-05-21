//
//  Errors.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/6/21.
//

import Foundation

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: Equatable {
    init(info: [String: Any?]) {
        if let message = info["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
    
    static func ==(lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
            case (.noInternetConnection, .noInternetConnection):
                return true
            case (.other, .other):
                return true
            case (.custom(let lhsMsg), .custom(let rhsMsg)):
                return lhsMsg == rhsMsg
            default:
                return false
        }
    }
}
