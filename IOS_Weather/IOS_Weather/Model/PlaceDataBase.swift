//
//  PlaceDataBase.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/12/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
enum TypeDataPlace: String {
    case namePlace = "namePlace"
    case latitudePlace = "latitudePlace"
    case longitudePlcae = "longitudePlace"
}

class PlaceDataBase: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(namePlace, forKey: TypeDataPlace.namePlace.rawValue)
        aCoder.encode(latitudePlace, forKey: TypeDataPlace.latitudePlace.rawValue)
        aCoder.encode(longitudePlace, forKey: TypeDataPlace.longitudePlcae.rawValue)
    }

    required init?(coder aDecoder: NSCoder) {
        namePlace = aDecoder.decodeObject(forKey: TypeDataPlace.namePlace.rawValue) as? String
        latitudePlace = aDecoder.decodeObject(forKey: TypeDataPlace.latitudePlace.rawValue) as? Float
        longitudePlace = aDecoder.decodeObject(forKey: TypeDataPlace.longitudePlcae.rawValue) as? Float
    }

    var namePlace: String?
    var longitudePlace: Float?
    var latitudePlace: Float?

    override init() {
    }

    init(namePlace: String?, latitudePlace: Float?, longitudePlace: Float?) {
        self.namePlace = namePlace
        self.latitudePlace = latitudePlace
        self.longitudePlace = longitudePlace
    }
}
