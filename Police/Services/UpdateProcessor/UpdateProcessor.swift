//
//  UpdateProcessor.swift
//  Police
//
//  Created by Riccardo on 03/02/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

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
}
