//
//  Endpoint.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 09/12/23.
//

import Foundation
import Moya

enum Endpoint {
    case register(name: String, email: String, password: String)
}
extension Endpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://tes-skill.datautama.com/test-skill/api/v1/auth/")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return.post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .register(name, email, password):
            let parameters: [String: Any] = ["name": name, "email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
