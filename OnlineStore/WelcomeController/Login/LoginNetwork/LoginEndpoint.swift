//
//  LoginEndpoint.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 10/12/23.
//

import Foundation
import Moya

enum LoginEndpoint {
    case login(email: String, password: String)
}
extension LoginEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://tes-skill.datautama.com/test-skill/api/v1/auth/")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return.post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .login(email, password):
            let parameters: [String: Any] = ["email": email, "password": password]
            print("Request Parameters: \(parameters)")
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
