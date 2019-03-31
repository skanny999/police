//
//  UpdateManager.swift
//  Police
//
//  Created by Riccardo on 28/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class UpdateManager {
    
    class func updatePeriods() {
        
        NetworkProvider.getRequest(forUrl: URLFactory.dateLastUpdated()) { (data, error) in
            if let error = error {
                print(error.debugDescription)
                return
            }
            if let data = data {
                
                UpdateProcessor.updatePeriods(withData: data)
                let allPeriods = CoreDataProvider.allPeriods()
            }
        }
        
    }
    
    class func updateCrimes(within mapRect: MKMapRect, completion:@escaping (Error?) -> Void) {

        
        NetworkProvider.getRequest(forUrl: URLFactory.urlForCrimesByArea(mapRect)) { (data, error) in
            
            if let error = error {
                print(error.debugDescription)
                completion(error)
                return
            }
            
            if let data = data {
                
                UpdateProcessor.updateObjects(ofType: Crime.self, fromData: data, completion: { (updated) in
                    if updated {
                        completion(nil)
                    }
                })
            }
        }
    }
    
    private func noNeedToUpdate(in mapRect: MKMapRect) -> Bool {
        

        
        return false
    }
}
