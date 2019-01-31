//
//  Constants.swift
//  Police
//
//  Created by Riccardo on 31/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

struct AppStatus {
    
    static let isTesting = UserDefaults.standard.bool(forKey: "isTest") 
}
