//
//  CreateProductModel.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 12/12/23.
//

import Foundation
import SwiftyJSON
struct CreateProductModel {
    let code: String?
    let message: String?
    
    init(json: JSON) {
        code = json["code"].stringValue
        message = json["message"].stringValue
    }
}
