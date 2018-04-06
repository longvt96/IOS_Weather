//
//  BaseResult.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
