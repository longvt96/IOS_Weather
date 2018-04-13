//
//  ConvertData.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/11/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation

class Common {

    class var sharedInstance: Common {
        struct Static {
            static let instance = Common()
        }
        return Static.instance
    }

    func convertFahrenheitToCelsius(temperatureFaharenheit: Float) -> String {
        return String(describing: Int(((temperatureFaharenheit - 32 ) / 1.8))) + Constant.kSymbolTemp
    }

    func convertMilesToKilomet( windSpeedMiles: Float) -> String {
        return String(describing: windSpeedMiles * 1.609)
    }

    func convertMilesToMeter( windSpeedMiles: Float) -> String {
        return String(describing: (windSpeedMiles * 1.609) / 3.6)
    }

    func converTimeStampToDate(timeStamp: Double, timeZone: String, timeFormat: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = timeFormat
        dayTimePeriodFormatter.timeZone = TimeZone(identifier: timeZone)
        return dayTimePeriodFormatter.string(from: date)
    }
}
