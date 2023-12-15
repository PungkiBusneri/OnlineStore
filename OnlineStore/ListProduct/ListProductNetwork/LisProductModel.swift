//
//  LisProductModel.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 12/12/23.
//

import Foundation
import SwiftyJSON
import Moya

struct ProductModel {
    let id: Int?
    let title: String?
    let description: String?
    let totalVariant: Int?
    let totalStock: Int?
    let price: Int?
    let imageURL: URL
    let variants: [VariantModel]
}

struct VariantModel {
    let id: Int?
    let imageURL: URL
    let name: String
    let price: Int
    let stock: Int
}

struct ProductListResponse {
    let code: String?
    let message: String?
    let data: ProductListData
}
struct ProductListData {
    let items: [ProductModel]?
    let perPage: Int?
    let total: Int?
    let lastPage: String?
    let nextPage: String?
    let prevPage: String?
}

extension TargetType {
    func mapModel(_ json: JSON) -> ProductListResponse? {
        let code = json["code"].stringValue
        let message = json["message"].stringValue
        let dataJSON = json["data"]
        
        let items = dataJSON["items"].arrayValue.compactMap { itemJSON in
            ProductModel(
                id : itemJSON["id"].intValue,
                title: itemJSON["title"].stringValue,
                description: itemJSON["description"].stringValue,
                totalVariant: itemJSON["total_variant"].intValue,
                totalStock: itemJSON["total_stock"].intValue,
                price: itemJSON["price"].intValue,
                imageURL: URL(string: itemJSON["image"].stringValue) ?? URL(fileURLWithPath: ""),
                variants: itemJSON["variants"].arrayValue.compactMap { variantJSON in
                    
                    VariantModel (
                        id: variantJSON["id"].intValue,
                        imageURL: URL(string: variantJSON["image"].stringValue) ?? URL(fileURLWithPath: ""),
                        name: variantJSON["name"].stringValue,
                        price: variantJSON["price"].intValue,
                        stock: variantJSON["stock"].intValue
                    )
                }
                
            )
        }
        let perPage = dataJSON["per_page"].intValue
        let total = dataJSON["total"].intValue
        let lastPage = dataJSON["last_page"].stringValue
        let nextPage = dataJSON["next_page"].string
        let prevPage = dataJSON["prev_page"].string
        
        let productListData = ProductListData (
            items: items,
            perPage: perPage,
            total: total,
            lastPage: lastPage,
            nextPage: nextPage,
            prevPage: prevPage
            
        )
        
        return ProductListResponse (code: code, message: message, data: productListData)
    }
}
