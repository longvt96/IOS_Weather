//
//  HistoryPlaceTableViewCell.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/16/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class HistoryPlaceTableViewCell: UITableViewCell {

    @IBOutlet private weak var namePlaceLabel: UILabel!
    @IBOutlet private weak var timePlaceLabel: UILabel!
    @IBOutlet private weak var temperaturePlaceLabel: UILabel!

    private let placeRepository = PlaceRepositoriesImp(api: APIService.share)
    var timeZonePlace: String?

    private func setContentForCell( place: Place, namePlace: String, timezonePlace: String) {
        if let tmpTimePlace = place.time, let tmpTemperaturePlace = place.temperature {
            self.namePlaceLabel.text = namePlace
            self.timePlaceLabel.text = Common.sharedInstance.converTimeStampToDate(
                timeStamp: tmpTimePlace, timeZone: timezonePlace,
                timeFormat: Constant.kHourAndMinuteFormat)
            let tmp = UserDefaults.standard.object(forKey: Constant.kChangeTemperatureKey) as? Int
            var tmpTemperature = "\(Int(tmpTemperaturePlace))" + Constant.kSymbolTemp
            guard let tmpTypeTemerature = tmp else {
                tmpTemperature = Common.sharedInstance.convertFahrenheitToCelsius(
                    temperatureFaharenheit: Float(tmpTemperaturePlace))
                self.temperaturePlaceLabel.text = tmpTemperature
                return
            }
            if tmpTypeTemerature == 0 {
                    tmpTemperature = Common.sharedInstance.convertFahrenheitToCelsius(
                        temperatureFaharenheit: Float(tmpTemperaturePlace))
            }
            self.temperaturePlaceLabel.text = tmpTemperature
        }
    }

    func getDataFromAPI(placeCell: PlaceDataBase) -> String? {
        var checkLoadData: String?
        checkLoadData = nil
        if let tmpLatitudePlace = placeCell.latitudePlace,
            let tmpLongitudePlace = placeCell.longitudePlace {
            placeRepository.getWeather(latitude: tmpLatitudePlace, longitude: tmpLongitudePlace) { (result) in
                switch result {
                case .success(let weatherResponse):
                    self.successGetDataApi(weatherResponse: weatherResponse, placeCell: placeCell)
                case .failure(let error):
                    checkLoadData = error?.errorMessage
                }
            }
        }
        return checkLoadData
    }

    func successGetDataApi(weatherResponse: WeatherResponse?, placeCell: PlaceDataBase) {
        if let weatherDemo = weatherResponse {
            DispatchQueue.main.async {
                let place = weatherDemo.place
                self.timeZonePlace = weatherDemo.timezone
                if let tmpTimeZone = self.timeZonePlace,
                    let tmpNamePlace = placeCell.namePlace,
                    let tmpPlace = place {
                    self.setContentForCell(
                        place: tmpPlace, namePlace: tmpNamePlace, timezonePlace: tmpTimeZone)
                }
            }
        }
    }
}
