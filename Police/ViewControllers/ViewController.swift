//
//  ViewController.swift
//  Police
//
//  Created by Riccardo on 17/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listOfForces = JSON(FileExtractor.extractJsonFile(withName: JSONFile.Forces.list))
        
        let forces = listOfForces.array!
        for force in forces {
            
            print(force["name"].string!)
        }
        
    }
}




