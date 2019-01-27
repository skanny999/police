//
//  ForceProcessor.swift
//  Police
//
//  Created by Riccardo on 27/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


struct ForceDetails: Codable {
    
    let id: String
    let name: String
    var neighbourhoods: [NeighbourhoodDetails]?
    
//    var dictionary: [String: Any] {
//
//        let neighbourhoodsArray: NSMutableArray = NSMutableArray()
//
//        for neighnourhood in neighbourhoods! {
//            neighbourhoodsArray.add(neighnourhood.nsdictionary)
//        }
//
//        return ["name":name,
//                "id":id,
//                "neighbourhoods":neighbourhoodsArray]
//    }
//
//    var nsdictionary: NSDictionary {
//
//        return dictionary as NSDictionary
//    }
}

struct NeighbourhoodDetails: Codable {
    let name: String
    let id: String
    
//    var dictionary: [String: Any] {
//        return["name": name,
//               "id": id]
//    }
//
//    var nsdictionary: NSDictionary {
//        return dictionary as NSDictionary
//    }
}



class ForceProcessor {
    
    class func createJsonFile() {
        
        retrieveForcesDetails { (allForcesDetails) in
            
            let encodedObject = try? JSONEncoder().encode(allForcesDetails)
            
            if let encodedObject = encodedObject,
                let jsonString = String(data: encodedObject, encoding: .utf8) {
                
                print(jsonString)
                ForceProcessor.saveJsonLocally(json: encodedObject)
            }
            
        }
    }
    
    class func saveJsonLocally(json: Data) {
        
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("forces.json")
        
        do {
            try json.write(to: fileUrl)
        } catch {
            print(error)
        }
    
    }
    
    
    
    class func retrieveForcesDetails(completion: @escaping ([ForceDetails]) -> Void) {
        
        var allForcesDetails:[ForceDetails] = []
        
        let forces = JSON(FileExtractor.extractJsonFile(withName: "AllForces")).array!
        
        var counter = 0

        for force in forces {
            
            var forceDetail = ForceDetails(id: force["id"].string!, name: force["name"].string!, neighbourhoods: nil)
            
            Alamofire.request("https://data.police.uk/api/\(force["id"].string!)/neighbourhoods").response { (response) in
                
                let jsonArray = try! JSON(data: response.data!).array!
                
                var allNeighbourhoodDetails:[NeighbourhoodDetails] = []
                for json in jsonArray {
                    allNeighbourhoodDetails.append(NeighbourhoodDetails(name: json["name"].string!, id: json["id"].string!))
                }
                
                forceDetail.neighbourhoods = allNeighbourhoodDetails
                allForcesDetails.append(forceDetail)
                
                counter += 1
                if counter == forces.count {
                    completion(allForcesDetails)
                }
            }
        }
    }
    
    
}