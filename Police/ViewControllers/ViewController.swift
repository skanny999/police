//
//  ViewController.swift
//  Police
//
//  Created by Riccardo on 17/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ForceProcessor.createJsonFile()
        
    }
    
    @IBAction func exportPlist(_ sender: Any) {
        
    }
    
    
}


