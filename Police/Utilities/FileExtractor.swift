//
//  FileExtractor.swift
//  Police
//
//  Created by Riccardo on 26/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class FileExtractor {
    
    static func extractJsonFile(withName name: String, forClass bundleClass: AnyClass) -> Data {
        
        do {
            guard let url = Bundle(for: bundleClass).url(forResource: name, withExtension: "json") else {
                
                fatalError("json file \(name) not found")
            }
            
            return try Data(contentsOf: url)
            
        } catch {

            fatalError(error.localizedDescription)
        }
    }
}
