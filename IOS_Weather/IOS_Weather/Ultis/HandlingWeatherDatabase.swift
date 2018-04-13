//
//  HandlingWeatherDatabase.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/13/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HandlingWeatherDatabase {

    private class func getManagerContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
           return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }

    class func insertWeather(place: PlaceDataBase) -> Bool {
        if checkData(place: place) == nil {
            do {
                if let managedContext = getManagerContext() {
                    if let placeEntity = NSEntityDescription.entity(forEntityName: Constant.KDatabaseName,
                                                                    in: managedContext) {
                        let placeObject = NSManagedObject(entity: placeEntity, insertInto: getManagerContext())
                        placeObject.setValue(place.namePlace, forKey: "namePlace")
                        placeObject.setValue(place.latitudePlace, forKey: "latitudePlace")
                        placeObject.setValue(place.longitudePlace, forKey: "longitudePlace")
                        try managedContext.save()
                        return true
                    } else {
                        return false
                    }
                }
            } catch {
                return false
            }
        }
        return false
    }

    class func fetchWeather() -> [PlaceDataBase] {
        let managedContext = getManagerContext()
        var tmpPlace = [PlaceDataBase]()
        let request = NSFetchRequest<NSManagedObject>(entityName: Constant.KDatabaseName)
        var tmpFetch = [NSManagedObject]()
        if let tmpManagedContext = managedContext {
            do {
                 tmpFetch = try tmpManagedContext.fetch(request)
                for index in tmpFetch {
                    let tmpNamePlace = index.value(forKey: "namePlace") as? String ?? ""
                    let tmpLatitudePlace = index.value(forKey: "latitudePlace") as? Float ?? 0.0
                    let tmpLongitudePlace = index.value(forKey: "longitudePlace") as? Float ?? 0.0
                    let tmpPlaceData = PlaceDataBase(namePlace: tmpNamePlace,
                                                     latitudePlace: tmpLatitudePlace,
                                                     longitudePlace: tmpLongitudePlace)
                    tmpPlace.append(tmpPlaceData)
                }
            } catch {
            }
        }
        return tmpPlace
    }

    class func cleanAllCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.KDatabaseName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        if let managedContext = getManagerContext() {
            do {
                try managedContext.execute(deleteRequest)
            } catch {
            }
        }
    }

    class func deleteWeather(place: PlaceDataBase) -> Bool {
        if let tmpData = checkData(place: place),
            let managedContext = getManagerContext() {
            do {
                managedContext.delete(tmpData)
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }

    class func checkData(place: PlaceDataBase) -> NSManagedObject? {
        let managedContext = getManagerContext()
        if let tmpLatitudePlace = place.latitudePlace,
            let tmpLongitudePlace = place.longitudePlace,
            let tmpManagedContext = managedContext {
            let request = NSFetchRequest<NSManagedObject>(entityName: Constant.KDatabaseName)
            var tmpFetch = [NSManagedObject]()
            do {
                tmpFetch = try tmpManagedContext.fetch(request)
                for index in tmpFetch {
                    let tmpLatitudeFetch = index.value(forKey: "latitudePlace") as? Float ?? 0.0
                    let tmpLongitudeFetch = index.value(forKey: "longitudePlace") as? Float ?? 0.0
                    if tmpLongitudeFetch == tmpLongitudePlace,
                        tmpLatitudeFetch == tmpLatitudePlace {
                        return index
                    }
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
