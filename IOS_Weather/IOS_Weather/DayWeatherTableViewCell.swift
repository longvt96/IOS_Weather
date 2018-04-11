//
//  DayWeatherTableViewCell.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/9/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class DayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayWeatherNameLabel: UILabel!
    @IBOutlet weak var dayWeatherIconImageView: UIImageView!
    @IBOutlet weak var dayWeatherTempMinLabel: UILabel!
    @IBOutlet weak var dayWeatherTempMaxLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setContentForCell(dayWeather: DayWeather, timeZonePlace: String?, typeTemperature: Int) {
        if let tmpIcon = dayWeather.icon,
            let tmpTimeZone = timeZonePlace,
            let tmpMaxTemp = dayWeather.maxTemperature,
            let tmpMinTemp = dayWeather.minTemperature,
            let tmpTime =  dayWeather.time {
            self.dayWeatherIconImageView?.image = UIImage(named: tmpIcon)
            self.dayWeatherNameLabel.text = Common.sharedInstance.converTimeStampToDate(
                timeStamp: tmpTime, timeZone: tmpTimeZone, timeFormat: Constant.kDayFormat)
            if typeTemperature == 1 {
                self.dayWeatherTempMaxLabel.text = String(
                    describing: Int((tmpMaxTemp))) + Constant.kSymbolTemp
                self.dayWeatherTempMinLabel.text = String(
                    describing: Int((tmpMinTemp))) + Constant.kSymbolTemp
            } else {
                self.dayWeatherTempMaxLabel.text =  Common.sharedInstance.convertFahrenheitToCelsius(
                    temperatureFaharenheit: Float(tmpMaxTemp))
                self.dayWeatherTempMinLabel.text =  Common.sharedInstance.convertFahrenheitToCelsius(
                    temperatureFaharenheit: Float(tmpMinTemp))
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
