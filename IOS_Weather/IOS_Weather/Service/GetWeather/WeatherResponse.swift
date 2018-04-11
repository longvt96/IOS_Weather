//
//  WeatherResponse.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse: Mappable {
    var place: Place?
    var hour: Hourly?
    var hourly: [Place]?
    var daily: [DayWeather]?
    var day: Daily?
    var timezone: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        self.place <- map["currently"]
        self.hour <- map["hourly"]
        if let hour = hour {
            self.hourly = hour.data
        }
        self.day <- map["daily"]
        if let day = day {
            self.daily = day.data
        }
        timezone <- map["timezone"]
    }
}
