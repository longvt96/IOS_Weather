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
    var selectedPlace: PlaceDataBase?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        getPlaceData()
        getSelectedPlace()
        initPageViewController()
        loadNavigationController()
    }

    func loadNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let backFromHistoryViewController = UserDefaults.standard.value(forKey: Constant.kBackViewControllerKey) as? Int
        guard self.selectedPlace != nil else {
            if let tmpBackView = backFromHistoryViewController {
                if tmpBackView == 1 {
                    UserDefaults.standard.removeObject(forKey: Constant.kBackViewControllerKey)
                    reloadRootView()
                }
            }
            return
        }
        let countReloadData = UserDefaults.standard.value(forKey: Constant.kIdentifierReloadViewController) as? Int
        guard countReloadData != nil else {
            UserDefaults.standard.set(1, forKey: Constant.kIdentifierReloadViewController)
            reloadRootView()
            return
        }
         UserDefaults.standard.removeObject(forKey: Constant.kIdentifierReloadViewController)
    }

    func reloadRootView() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let windowView = appDelegate?.window
        if let tmpWindowView = windowView {
            UIView.transition(with: tmpWindowView, duration: 1.5,
                              options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                                tmpWindowView.rootViewController = self.storyboard?
                                .instantiateViewController(
                                    withIdentifier: Constant.kIdentifierNavigationController)
                                    as? UINavigationController
            }, completion: nil)
        }
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
        self.viewControllerList = [MainViewController]()
        if self.placeData.count  > self.viewControllerList.count {
            viewControllerList = [MainViewController]()
            for _ in 0..<self.placeData.count {
                let mainViewController = self.storyboard?.instantiateViewController(
                    withIdentifier: Constant.kIdentifierMainViewController)
                if let tmpMainViewController = mainViewController as? MainViewController {
                    self.viewControllerList.append(tmpMainViewController)
                    self.sendDataWeather(placedata: self.placeData[self.viewControllerList.count - 1])
                }
            }
        }
        self.setFirstPageViewController()
         getCurrentLocation()
    }

    func sendDataWeather(placedata: PlaceDataBase) {
        self.viewControllerList[self.viewControllerList.count - 1].namePlace =
            placedata.namePlace
        self.viewControllerList[self.viewControllerList.count - 1].latitudePlace =
            placedata.latitudePlace
        self.viewControllerList[self.viewControllerList.count - 1].longitudePlace =
            placedata.longitudePlace
    }

    func getSelectedPlace() {
        let decoded  = UserDefaults.standard.object(forKey: Constant.kMainViewControllerKey) as? Data
        if let tmpDecoded = decoded {
            self.selectedPlace = NSKeyedUnarchiver.unarchiveObject(with: tmpDecoded) as? PlaceDataBase
        }
    }

    func setFirstPageViewController() {
        guard self.selectedPlace != nil else {
            if let first = self.viewControllerList.first {
                self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
            }
            return
        }
        for index in 0..<self.viewControllerList.count {
            if let tmpSelectePlace = self.selectedPlace {
                if self.viewControllerList[index].namePlace == tmpSelectePlace.namePlace,
                    self.viewControllerList[index].latitudePlace == tmpSelectePlace.latitudePlace,
                    self.viewControllerList[index].longitudePlace == tmpSelectePlace.longitudePlace {
                    self.setViewControllers([self.viewControllerList[index]],
                                            direction: .forward, animated: true, completion: nil)
                    break
                }
            }
        }
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
                    .instantiateViewController(withIdentifier: Constant.kIdentifierMainViewController)
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

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if self.viewControllerList.isEmpty {
            let historyViewController = self.storyboard?
                .instantiateViewController(
                    withIdentifier: Constant.kIdentifierHistoryViewController) as? HistoryPlaceViewController
            if let tmpHistoryViewController = historyViewController {
                self.navigationController?.pushViewController(tmpHistoryViewController, animated: true)
            }
        }
    }
}
