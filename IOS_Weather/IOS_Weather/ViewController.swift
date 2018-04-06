//
//  ViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let placeRepository: PlaceRepositories = PlaceRepositoriesImp(api: APIService.share)

    override func viewDidLoad() {
        super.viewDidLoad()
        placeRepository.getweather(lat: 37.8267, lot: -122.4233) { (result) in
            switch result {
            case .success(let weatherResponse):
                if let weatherdemo = weatherResponse {
                   let place = weatherdemo.place
                    print("place: \(place!.time!) \(String(describing: place!.summary!))")
                }
            case .failure(let error):
                print("\(String(describing: error))")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
