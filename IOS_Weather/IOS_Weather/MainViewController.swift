//
//  ViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class MainViewController: BaseClassViewController {

    private let placeRepository: PlaceRepositories = PlaceRepositoriesImp(api: APIService.share)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingOnParent()
        placeRepository.getweather(lat: 37.8267, lot: -122.4233) { (result) in
            switch result {
            case .success(let weatherResponse):
                if let weatherdemo = weatherResponse {
                   let place = weatherdemo.place
                    print("place: \(place!.time!) \(String(describing: place!.summary!))")
                }
                self.hidenLoading()
            case .failure(let error):
                print("\(String(describing: error))")
                self.hidenLoading()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
