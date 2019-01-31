//
//  ViewController.swift
//  Police
//
//  Created by Riccardo on 17/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved
//

import UIKit

import Foundation


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppStatus.isTesting {
            print("testing")
        } else {
            print("not testing")
        }
        
    }

    
    
}


