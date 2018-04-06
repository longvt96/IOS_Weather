//
//  Hourly.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/6/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import ObjectMapper

class Hourly: BaseModel {
    var data: [Place]?

    required init?(map: Map) {
        self.mapping(map: map)
    }

    func mapping(map: Map) {
        data <- map["data"]
    }
}
