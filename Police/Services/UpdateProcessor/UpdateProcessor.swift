//
//  UpdateProcessor.swift
//  Police
//
//  Created by Riccardo on 03/02/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateProcessor {
    
    static func updateObject<T: Updatable>(ofType updatableClass: T.Type, fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            if let json = try? JSON(data: data) {
                updatableClass.managedObject(withJson: json, in: context)
                CoreDataManager.shared.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    static func updateObjects<T: Updatable>(ofType updatableClass: T.Type, fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            if let jsonArray = try! JSON(data: data).array {
                
                for objectData in jsonArray {

                    updatableClass.managedObject(withJson: objectData, in: context)
                }
                
                CoreDataManager.shared.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    static func updateStopAndSearch(fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            if let jsons = try? JSON(data: data).array {
                if jsons.isEmpty {
                    completion(false)
                    return
                }
                for json in jsons {
                   StopAndSearch.managedObject(withJson: json, in: context)
                }
                CoreDataManager.shared.save()
                DispatchQueue.main.async {
                    completion(true)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    
    static func updatePeriods(withData data: Data) {
        
        CoreDataManager.performViewTask { (context) in
            if let json = try? JSON(data: data),
                let date = json["date"].string?.periodDate {
                let availableDates = date.previousAvailableDates().compactMap { $0 as NSDate }
                
                if let currentlySavedPeriodDates = CoreDataProvider.allPeriods()?.compactMap({ $0.date }) {
                    
                    for date in availableDates {
                        
                        if !currentlySavedPeriodDates.contains(where: {$0 === date}) {
                            
                            Period.createPeriod(fromDate: date,
                                                isSelected: date == availableDates.last!,
                                                in: context)
                        }
                    }
                    
                } else {
                    
                    for date in availableDates {
                        
                        Period.createPeriod(fromDate: date,
                                            isSelected: date == availableDates.last!,
                                            in: context)
                    }
                }
                do {
                    try context.save()
                } catch {
                    print("Couldn't save processed periods: \(error.localizedDescription)")
                }
            }
        }
    }
    
    static func neighbourhoodId(fromData data: Data?) -> (force:String, identifier: String)? {
        
        if let data = data,
            let json = try? JSON(data: data),
            let force = json["force"].string,
            let identifier = json["neighbourhood"].string {
            
            return (force, identifier)
        }
        return nil
    }
    
    static func processNeighbourhood(fromData datas: [Data]) {
        
        for (index, data) in datas.enumerated() {
            
            if let json = try? JSON(data: data) {
                
                if let locations = json["locations"].array {
                    
                    if !locations.isEmpty {
                        print(locations)
                    }
                }
                
            } else {
                
                print("/n/n/n No data at index \(index)")
            }
            
            
        }
        
        
        
    }
}
