//
//  URLFactory.swift
//  Police
//
//  Created by Riccardo on 26/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

struct URLFactory {
    
    static let baseUrl = "https://data.police.uk/api/"
    
    enum Forces: String {
        case list = "forces"
        case specificForce = "forces/%@" //force name
        case officers = "forces/%@/people" // forceName
    }
    
    enum Crimes: String {
    
        case byExactLocationId = "crimes-at-location?%@location_id=%%@" //date in format `"date=%@-%@&",year,month`, locationId
        case byExactLocation = "crimes-at-location?%@lat=%@&lng=%@" // date as above, lat,long
        case byLocationRadius = "crimes-street/all-crime?lat=%@&lng=%@" //lat, long
        case byArea = "crimes-street/all-crime?poly=%@" //lat,long:lat,long:...
        case addDate = "date=%@-%@" //year,month
    }
    
    enum Ourcomes: String {
        
        case byLocationId = "outcomes-at-location?%@location_id=%@" //date in format `"date=%@-%@&",year,month`, locationId
        case byLocation = "outcomes-at-location?%@lat=%@&lng=%@" // date as above, lat,long
        case byArea = "outcomes-at-location?%@poly=%@" //date as above, lat,long:lat,long:...
    }
    
    
    
    
    
}
