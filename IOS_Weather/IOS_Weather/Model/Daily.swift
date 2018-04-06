//
//  Daily.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/6/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import ObjectMapper

struct Daily: BaseModel {

    var data: [DayWeather]?

    init?(map: Map) {
        self.mapping(map: map)
    }

    mutating func mapping(map: Map) {
        data <- map["data"]
    }

}
