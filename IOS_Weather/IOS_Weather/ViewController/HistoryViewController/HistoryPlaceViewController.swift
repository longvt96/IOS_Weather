//
//  HistoryPlaceViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/6/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit
import GooglePlaces

class HistoryPlaceViewController: BaseClassViewController, AlertViewController, UIScrollViewDelegate {

    @IBOutlet private weak var historyPlaceTableView: UITableView!

    var dataPlace = [PlaceDataBase]()
    private let placeRepository = PlaceRepositoriesImp(api: APIService.share)
    var timeZonePlace: String?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        loadPlaceFromHistory()
        initRefeshControl()
        autoReloadDataEachMinute()
    }

    func autoReloadDataEachMinute() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(Constant.kTimeAutuReloadHistory), repeats: true) { (_) in
            self.reloadData()
        }
    }

    func initNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let addBarButton = UIBarButtonItem.init(title: "ADD",
                                                style: UIBarButtonItemStyle.done, target: self,
                                                action: #selector(addNewPlace))
        self.navigationItem.rightBarButtonItems = [addBarButton]
        let  backBarButton = UIBarButtonItem.init(title: "BACK",
                                                style: UIBarButtonItemStyle.done, target: self,
                                                action: #selector(clickBarButtonBack))
        self.navigationItem.leftBarButtonItems = [backBarButton]
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @objc func addNewPlace() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil)
    }

    @objc func clickBarButtonBack() {
        UserDefaults.standard.set(1, forKey: Constant.kBackViewControllerKey)
        UserDefaults.standard.removeObject(forKey: Constant.kMainViewControllerKey)
        self.navigationController?.popViewController(animated: true)
    }

    func initRefeshControl() {
        if #available(iOS  10.0, *) {
            self.historyPlaceTableView.refreshControl = refreshControl
        } else {
            self.historyPlaceTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string: "please wait")
        self.historyPlaceTableView.rowHeight = UITableViewAutomaticDimension
    }

    @objc func refreshData() {
        reloadData()
        self.refreshControl.endRefreshing()
    }

    func loadPlaceFromHistory() {
        dataPlace = HandlingWeatherDatabase.fetchWeather()
    }

    func reloadData() {
        loadPlaceFromHistory()
        self.historyPlaceTableView.reloadData()
    }

    func showAlertWhenAddNewPlaceFailed() {
        self.showAlertView(title: "Error", message: "Không thêm được địa điểm mới này !",
                           cancelButton: "OK", otherButtons: nil, type: UIAlertControllerStyle.alert,
                           cancelAction: nil, otherAction: nil)
    }
}

extension HistoryPlaceViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let newPlace = PlaceDataBase(namePlace: place.name,
                                     latitudePlace: Float(place.coordinate.latitude),
                                     longitudePlace: Float(place.coordinate.longitude))
        guard HandlingWeatherDatabase.insertWeather(place: newPlace) else {
            dismiss(animated: true, completion: nil)
            self.showAlertWhenAddNewPlaceFailed()
            return
        }
        self.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.showAlertWhenAddNewPlaceFailed()
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension HistoryPlaceViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPlace.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constant.KIdentifierCellHistory) as? HistoryPlaceTableViewCell else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: Constant.KIdentifierCellHistory, for: indexPath)
                return cell
        }
        if let errorLoadData = (cell.getDataFromAPI(placeCell: self.dataPlace[indexPath.row])) {
            self.showAlertView(title: "Error", message: errorLoadData, cancelButton: "OK",
                               otherButtons: nil, type: UIAlertControllerStyle.alert,
                               cancelAction: nil, otherAction: nil)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.historyPlaceTableView.beginUpdates()
            if !HandlingWeatherDatabase.deleteWeather(place: self.dataPlace[indexPath.row]) {
                self.showAlertView(title: "Error", message: "Delete Place Error",
                                   cancelButton: "OK", otherButtons: nil, type: UIAlertControllerStyle.alert,
                                   cancelAction: nil, otherAction: nil)
            }
            self.historyPlaceTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            reloadData()
            self.historyPlaceTableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.view.frame.size.height / 8)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.dataPlace[indexPath.row])
        UserDefaults.standard.set(encodedData, forKey: Constant.kMainViewControllerKey)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: Constant.kBackViewControllerKey)
        self.navigationController?.popViewController(animated: true)
    }
}
