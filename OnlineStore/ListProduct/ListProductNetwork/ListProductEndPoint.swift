//
//  ListProductEndPoint.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 12/12/23.
//

import Foundation
import Moya

enum ListProductEndPoint {
    case getProductList(page: Int, perPage: Int, search: String?, orderDirection: String?)
}
extension ListProductEndPoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://tes-skill.datautama.com/test-skill/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getProductList:
            return "/product"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProductList:
            return .get
        }
    }
    
    var sampleData: Data{
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .getProductList(let page, let perPage, let search, let orderDirection):
            var parameters: [String:Any] = ["page": page, "per_page": perPage]
            
            if let search = search {
            parameters["search"] = search
            }
            
            if let orderDirection = orderDirection {
                parameters["order_direction"] = orderDirection
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer 68|OfH83aFIxZg1M3CDCgQkFHY7nkjwWhdq0THe7OHl"
        ]
    }
    
    
}
