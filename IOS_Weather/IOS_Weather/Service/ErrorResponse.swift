//
//  ErrorResponse.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var code: String?
    var message: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        code <- map["code"]
        message <- map["error"]
    }
}
