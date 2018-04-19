//
//  CustomRequestAdapter.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import Alamofire

class CustomRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Mozilla/5.0 AppleWebKit/601.1.46 Version/9.0 Mobile/13G34 Safari/601.1",
                            forHTTPHeaderField: "User-Agent")
        return urlRequest
    }
}
