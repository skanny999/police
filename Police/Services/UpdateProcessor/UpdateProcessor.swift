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
            
            updatableClass.managedObject(withData: data, in: context)
            CoreDataManager.shared().save(context)
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    static func updateObjects<T: Updatable>(ofType updatableClass: T.Type, fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            if let jsonArray = try! JSON(data: data).array {
                
                for objectData in jsonArray {
                    
                    let rawData = try! objectData.rawData(options: .prettyPrinted)
                    
                    updatableClass.managedObject(withData: rawData, in: context)

                }
                
                CoreDataManager.shared().save(context)
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            

        }
    }
    
    static func updateStopAndSearch(fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performViewTask { (context) in
            
            StopAndSearch.managedObject(withData: data, in: context)
            CoreDataManager.shared().save(context)
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
}
