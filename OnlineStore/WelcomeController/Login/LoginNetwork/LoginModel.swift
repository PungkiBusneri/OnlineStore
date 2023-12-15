//
//  LoginModel.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 08/12/23.
//

import Foundation
import SwiftyJSON


struct LoginModel {
    let code: String
    let message: String
    let data: DataList

    init(json: JSON) {
        code = json["code"].stringValue
        message = json["message"].stringValue
        data = DataList(json: json["data"])
        print("Code: \(code), Message: \(message)")
    }
}

struct DataList {
    let id: Int
    let token: String

    init(json: JSON) {
        id = json["id"].intValue
        token = json["token"].stringValue
    }
}
