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
    
    static func updateCrime(fromData data: Data, completion: @escaping (Bool) -> Void) {
        
        CoreDataManager.performBackgroundTask { (context) in
            
            Crime.crime(withData: data, in: context)
            CoreDataManager.shared().save(context)
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    
    
    
    
}
