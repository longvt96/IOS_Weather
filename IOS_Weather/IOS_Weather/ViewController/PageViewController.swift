//
//  PageViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/6/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit
import CoreLocation

class PageViewController: UIPageViewController {

    var placeData = [PlaceDataBase]()
    var viewControllerList = [MainViewController]()
    var locationManager = CLLocationManager()
    var currentPlace = PlaceDataBase()
    var selectedPlace: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        getCurrentLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        getPlaceData()
        initPageViewController()
    }

    func getPlaceData() {
        placeData = HandlingWeatherDatabase.fetchWeather()
    }

    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func initPageViewController() {
        for _ in 0..<self.placeData.count {
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
            if let tmpMainViewController = mainViewController as? MainViewController {
                self.viewControllerList.append(tmpMainViewController)
                self.sendDataWeather(placedata: self.placeData[self.viewControllerList.count - 1])
            }
        }
        self.setFirstPageViewController()
    }

    func sendDataWeather(placedata: PlaceDataBase) {
        self.viewControllerList[self.viewControllerList.count - 1].namePlace =
            placedata.namePlace
        self.viewControllerList[self.viewControllerList.count - 1].latitudePlace =
            placedata.latitudePlace
        self.viewControllerList[self.viewControllerList.count - 1].longitudePlace =
            placedata.longitudePlace
    }

    func setFirstPageViewController() {
        if self.selectedPlace == nil {
            if let first = self.viewControllerList.first {
                self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
                }
        } else {
            for index in 0..<self.viewControllerList.count {
                guard self.viewControllerList[index] == self.selectedPlace else {
                    continue
                }
                self.setViewControllers([self.viewControllerList[index]],
                                        direction: .forward, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let tmpVc = (viewController as? MainViewController) {
            guard let vcIndex = viewControllerList.index(of: tmpVc ) else {
                return nil
            }
            let previousIndex = vcIndex - 1
            guard previousIndex >= 0  else {
                return nil
            }
            guard previousIndex < viewControllerList.count else {
                return nil
            }
            return viewControllerList[previousIndex]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let tmpVC = viewController as? MainViewController {
            guard let vcIndex = viewControllerList.index(of: tmpVC) else {
                return nil
            }
            let nextIndex = vcIndex + 1
            guard viewControllerList.count != nextIndex  else {
                return nil
            }
            guard viewControllerList.count > nextIndex else {
                return nil
            }
            return viewControllerList[nextIndex]
        }
        return nil
    }
}

extension PageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let tmpCurrentPlace = PlaceDataBase()
        let location = locations[0]
        tmpCurrentPlace.latitudePlace = Float(location.coordinate.latitude)
        tmpCurrentPlace.longitudePlace = Float(location.coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location,
                                completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                tmpCurrentPlace.namePlace = firstLocation?.name
                let mainViewController = self.storyboard?
                    .instantiateViewController(withIdentifier: "mainVC")
                if let tmpMainViewController = mainViewController as? MainViewController {
                    if self.viewControllerList.count > self.placeData.count {
                        self.viewControllerList.remove(at: self.viewControllerList.count - 1)
                    }
                    self.viewControllerList.append(tmpMainViewController)
                    self.sendDataWeather(placedata: tmpCurrentPlace)
                    if self.placeData.isEmpty {
                       self.setFirstPageViewController()
                    }
                }
            }
        })
    }
}
