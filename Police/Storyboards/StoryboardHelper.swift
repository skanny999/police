//
//  StoryboardHelper.swift
//  Police
//
//  Created by Riccardo Scanavacca on 14/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import UIKit

class Storyboard {
    
    private static func mainStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func searchResultsController() -> SearchResultsController {

        return self.mainStoryboard().instantiateViewController(withIdentifier: "SearchResultsController") as! SearchResultsController
        
    }
    
}
