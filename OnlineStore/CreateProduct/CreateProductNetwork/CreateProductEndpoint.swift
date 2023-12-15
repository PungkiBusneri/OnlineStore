//
//  CreateProductEndpoint.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 12/12/23.
//

import Foundation
import Moya

enum CreateProductEndpoint {
    case createProduct (title: String, description: String, variant: [Variants])
}
struct Variants {
    let name: String
    let image: String
    let price: Int
    let stock: Int
}
extension CreateProductEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://tes-skill.datautama.com/test-skill/api/v1/")!
    }
    
    var path: String {
        switch self {
        case .createProduct:
            return "product"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createProduct:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createProduct(let title, let description, let variants):
            
            let json: [String: Any] = [
                "title": title,
                "description": description,
                "variants": variants.map { variant in
                    [
                        "name": variant.name,
                        "image": variant.image,
                        "price": variant.price,
                        "stock": variant.stock
                    ]
                }
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
                return .requestPlain
            }
            
            return .requestData(jsonData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createProduct:
            
            let token = "68|OfH83aFIxZg1M3CDCgQkFHY7nkjwWhdq0THe7OHl"
            return ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
            
        }
    }
}
