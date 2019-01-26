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
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)") // response serialization result
            
            let swiftyJSON = JSON(response.result.value as Any)
            let origin = swiftyJSON["origin"].string
            print(origin!)
            
//            if let json = response.result.value {
//                let swifty = JSON(json)
//
//                let origin = swifty["origin"].string
//                print(origin)
//            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            
            
        }
    }


}

