//
//  DayWeather.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/4/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit
import ObjectMapper

class DayWeather: BaseModel {
    var time: Int?
    var icon: String?
    var maxTemperature: Int?
    var minTemperature: Int?

    required init?(map: Map) {
        self.mapping(map: map)
    }

    func mapping(map: Map) {
        time <- map["time"]
        icon <- map["icon"]
        maxTemperature <- map["temperatureHigh"]
        minTemperature <- map["temperatureLow"]
    }

}
