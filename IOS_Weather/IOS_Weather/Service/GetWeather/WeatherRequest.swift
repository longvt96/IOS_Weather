//
//  WeatherRequest.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class WeatherRequest: BaseRequest {
    required init(lat: Float, lot: Float) {
        let body: [String: Any] = [:]
        let urltmp = URLs.APIBaseUrl + "\(lat),\(lot)"
        super.init(url: urltmp, requestType: .get, body: body)
    }
}
