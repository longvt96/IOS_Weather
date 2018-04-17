//
//  ViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/5/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit

class MainViewController: BaseClassViewController, UIScrollViewDelegate, AlertViewController {

    @IBOutlet weak var dataWeatherScrollView: UIScrollView!
    @IBOutlet weak var dayWeatherTableView: UITableView!
    @IBOutlet weak var topViewNameContraint: NSLayoutConstraint!
    @IBOutlet weak var heightViewTempContraint: NSLayoutConstraint!
    @IBOutlet weak var viewTemp: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var hourWeatherCollectionView: UICollectionView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var ozoneLabel: UILabel!
    @IBOutlet weak var changeWindSegment: UISegmentedControl!
    @IBOutlet weak var changeTemperatureSegment: UISegmentedControl!

    var dataDayArray = [DayWeather]()
    var dataHourArray = [Place]()
    var latitudePlace: Float?
    var longitudePlace: Float?
    var namePlace: String?
    var currentPlace: Place?
    var timeZonePlace: String?
    var pointTapScroll = CGFloat(0.0)
    private let placeRepository = PlaceRepositoriesImp(api: APIService.share)
    var refreshControlScrollView: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCode()
        self.setRefreshControl()
    }

    func initCode() {
        self.dataWeatherScrollView.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.heightViewTempContraint.constant = self.view.frame.size.height / 6
        Timer.scheduledTimer(withTimeInterval: TimeInterval(Constant.kTimeAutoReloadData), repeats: true) { (_) in
            self.loadData(false)
        }
        UserDefaults.standard.set(0, forKey: Constant.kChangeTemperatureKey)
    }

    func setRefreshControl() {
        self.refreshControlScrollView = UIRefreshControl()
        self.refreshControlScrollView?.tintColor = UIColor.blue
        self.refreshControlScrollView?.attributedTitle = NSAttributedString(string: "Reload data...")
        self.refreshControlScrollView?.addTarget(self,
                                                 action: #selector(refreshData), for: UIControlEvents.valueChanged)
        self.dataWeatherScrollView.addSubview(refreshControlScrollView!)
    }

    @objc func refreshData() {
        self.loadData(false)
        self.refreshControlScrollView?.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loadData(true)
    }

    func loadData(_ showloading: Bool) {
        print("reload")
        if showloading {
            self.showLoadingOnParent()
        }
        if let tmpLatitudePlace = self.latitudePlace,
            let tmpLongitudePlace = self.longitudePlace {
            placeRepository.getWeather(latitude: tmpLatitudePlace, longitude: tmpLongitudePlace) { (result) in
                switch result {
                case .success(let weatherResponse):
                    self.successGetDataApi(weatherResponse: weatherResponse, showloading: showloading)
                case .failure(let error):
                    self.failureGetDataFromApi(error: error, showloading: showloading)
                }
            }
        }
    }

    func failureGetDataFromApi(error: BaseError?, showloading: Bool) {
        self.showAlertView(title: "Error",
                           message: "Error load API: \n \(String(describing: error?.errorMessage!))",
            cancelButton: "OK", otherButtons: nil,
            type: UIAlertControllerStyle.alert, cancelAction: nil, otherAction: nil)
        if showloading {
            self.hidenLoading()
        }
    }
    func successGetDataApi(weatherResponse: WeatherResponse?, showloading: Bool) {
        if let weatherDemo = weatherResponse {
            let place = weatherDemo.place
            self.currentPlace = place
            self.setData()
            if let tmpDayData = weatherDemo.daily,
                let tmpHourData = weatherDemo.hourly {
                self.dataDayArray = tmpDayData
                self.dataHourArray = tmpHourData
                self.dayWeatherTableView.reloadData()
                self.hourWeatherCollectionView.reloadData()
                self.timeZonePlace = weatherDemo.timezone
            } else {
                self.showAlertView(title: "Error", message: "Data nil!",
                                   cancelButton: "OK", otherButtons: nil,
                                   type: UIAlertControllerStyle.alert,
                                   cancelAction: nil, otherAction: nil)
            }
        }
        if showloading {
            self.hidenLoading()
        }
    }
    func setData() {
        if let tmpTemperature = self.currentPlace?.temperature,
            let tmpOzone = self.currentPlace?.ozone,
            let tmpCloudCover = self.currentPlace?.cloudCover,
            let tmpWindSpeed = self.currentPlace?.windSpeed,
            let tmpHumidity = self.currentPlace?.humidity,
            let tmpNamePlace = self.namePlace {
            self.namePlaceLabel.text = tmpNamePlace
            if self.changeTemperatureSegment.selectedSegmentIndex == 1 {
                self.temperatureLabel.text = String(describing: Int((tmpTemperature))) + Constant.kSymbolTemp
            } else {
                self.temperatureLabel.text =  Common.sharedInstance.convertFahrenheitToCelsius(
                    temperatureFaharenheit: Float(tmpTemperature))
            }
            self.weatherLabel.text = self.currentPlace?.summary
            self.cloudLabel.text = String(describing: tmpCloudCover * 100 ) + Constant.kSymbolPercen
            if self.changeWindSegment.selectedSegmentIndex == 0 {
                self.windLabel.text = Common.sharedInstance.convertMilesToKilomet(
                    windSpeedMiles: Float(tmpWindSpeed))
            } else {
                self.windLabel.text = Common.sharedInstance.convertMilesToMeter(
                    windSpeedMiles: Float(tmpWindSpeed))
            }
            self.humidityLabel.text = String(describing: tmpHumidity * 100 ) + Constant.kSymbolPercen
            self.ozoneLabel.text = String(describing: (tmpOzone))
        }
    }

    @IBAction func changeTemperatureSegment(_ sender: Any) {
        self.dayWeatherTableView.reloadData()
        self.hourWeatherCollectionView.reloadData()
        self.setData()
        UserDefaults.standard.set(self.changeTemperatureSegment.selectedSegmentIndex,
                                  forKey: Constant.kChangeTemperatureKey)
    }

    @IBAction func goHistoryViewControllerButton(_ sender: Any) {
        let historyViewController = self.storyboard?.instantiateViewController(
            withIdentifier: Constant.kIdentifierHistoryViewController)
        if let tmpHistoryViewController = historyViewController {
            self.navigationController?.pushViewController(tmpHistoryViewController, animated: true)
        }
    }

    @IBAction func changeWindSegment(_ sender: Any) {
       self.setData()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.kHourWeather
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: Constant.kIdentifierItem, for: indexPath) as? HourWeatherCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.kIdentifierItem, for: indexPath)
            return cell
        }
        if !self.dataHourArray.isEmpty {
            cell.setContentForItem(hourWeather: dataHourArray[indexPath.row],
                                   timeZonePlace: self.timeZonePlace,
                                   typeTemperature: self.changeTemperatureSegment.selectedSegmentIndex)
        }
        return cell
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointTapScroll = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > pointTapScroll { // scroll up
            UIView.animate(withDuration: Constant.kAnimationDuration) {
                self.topViewNameContraint.constant = CGFloat(Constant.kSpaceNameAfter)
                self.heightViewTempContraint.constant = 0.0
                self.viewTemp.alpha = 0
             self.view.layoutIfNeeded()
            }
        } else { // scroll down
            UIView.animate(withDuration: Constant.kAnimationDuration) {
                self.topViewNameContraint.constant = CGFloat(Constant.kSpaceNameAfter)
                self.viewTemp.alpha = 1
                if scrollView.contentOffset.y == 0 {
                    self.heightViewTempContraint.constant =  self.view.frame.size.height / 6
                }
             self.view.layoutIfNeeded()
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellItemSize = collectionView.frame.size
        cellItemSize.width = self.view.frame.size.width / CGFloat(Constant.kCountItem) -
            CGFloat((Constant.kSpaceItem * 2))
        return cellItemSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(Constant.kSpaceItem), left: CGFloat(Constant.kSpaceItem),
                            bottom: CGFloat(Constant.kSpaceItem), right: CGFloat(Constant.kSpaceItem))
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDayArray.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: Constant.kIdentifierCell) as? DayWeatherTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.kIdentifierCell, for: indexPath)
            return cell
        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        if !self.dataDayArray.isEmpty {
            cell.setContentForCell(dayWeather: dataDayArray[indexPath.row + 1],
                timeZonePlace: self.timeZonePlace,
                typeTemperature: self.changeTemperatureSegment.selectedSegmentIndex)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dayWeatherTableView.frame.height / CGFloat(Constant.kDayOfWeek)
    }
}
