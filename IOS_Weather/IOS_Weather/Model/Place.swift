//
//  Place.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/4/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit
import ObjectMapper

class Place: BaseModel {

    var time: Double?
    var summary: String?
    var icon: String?
    var temperature: Float?
    var humidity: Float?
    var windSpeed: Float?
    var cloudCover: Float?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        time <- map["time"]
        summary <- map["summary"]
        icon <- map["icon"]
        temperature <- map["precipProbability"]
        humidity <- map["humidity"]
        windSpeed <- map["windSpeed"]
        cloudCover <- map["cloudCover"]
    }
}
