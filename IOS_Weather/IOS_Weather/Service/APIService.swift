//
//  APIService.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct APIService {

    static let share = APIService()

    private var alamofireManager = Alamofire.SessionManager.default

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: config)
        alamofireManager.adapter = CustomRequestAdapter()
    }

    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?, _ error: BaseError?) -> Void) {
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body,
                                 encoding: input.encoding).validate(statusCode: 200..<500)
            .responseJSON { (response) in
                print(response.request?.url ?? "Error")
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = Mapper<T>().map(JSONObject: value)
                            completion(object, nil)
                        } else {
                            if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                                completion(nil, BaseError.apiFailure(error: error))
                            } else {
                                completion(nil, BaseError.httpError(httpCode: statusCode))
                            }
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
        }
    }
}
