//
//  PlaceRepositories.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import ObjectMapper

protocol PlaceRepositories {
    func getWeather(latitude: Float, longitude: Float, completion: @escaping (BaseResult<WeatherResponse>) -> Void)
}

class PlaceRepositoriesImp: PlaceRepositories {

    private var api: APIService?

    required init(api: APIService) {
        self.api = api
    }

    func getWeather(latitude: Float, longitude: Float, completion: @escaping (BaseResult<WeatherResponse>) -> Void) {
        let input = WeatherRequest(lat: latitude, lot: longitude)
        api?.request(input: input) { (object: WeatherResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
