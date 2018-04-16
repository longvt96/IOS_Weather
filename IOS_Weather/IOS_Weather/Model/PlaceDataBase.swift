//
//  PlaceDataBase.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/12/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation

class PlaceDataBase {

    var namePlace: String?
    var longitudePlace: Float?
    var latitudePlace: Float?

    init() {
    }

    init(namePlace: String?, latitudePlace: Float?, longitudePlace: Float?) {
        self.namePlace = namePlace
        self.latitudePlace = latitudePlace
        self.longitudePlace = longitudePlace
    }
}
