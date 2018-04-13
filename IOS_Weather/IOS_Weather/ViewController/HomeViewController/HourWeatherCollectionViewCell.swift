//
//  HourWeatherCollectionViewCell.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/9/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class HourWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hourWeatherLabel: UILabel!
    @IBOutlet weak var hourWeatherIconImageView: UIImageView!
    @IBOutlet weak var hourWeatherTempLabel: UILabel!

    func setContentForItem(hourWeather: Place, timeZonePlace: String?, typeTemperature: Int) {
        if let tmpDate = hourWeather.time,
            let tmpTemperature = hourWeather.temperature,
            let tmpIcon = hourWeather.icon,
            let tmpTimeZone = timeZonePlace {
            self.hourWeatherLabel.text = Common.sharedInstance.converTimeStampToDate(
                timeStamp: tmpDate, timeZone: tmpTimeZone, timeFormat: Constant.kHourFormat)
            if typeTemperature == 1 {
                self.hourWeatherTempLabel.text = String(
                    describing: Int((tmpTemperature))) + Constant.kSymbolTemp
            } else {
                self.hourWeatherTempLabel.text =  Common.sharedInstance.convertFahrenheitToCelsius(
                    temperatureFaharenheit: Float(tmpTemperature))
            }
            self.hourWeatherIconImageView.image = UIImage(named: tmpIcon)
        }
    }
}
