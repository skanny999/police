//
//  NetworkProvider.swift
//  Police
//
//  Created by Riccardo on 26/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class NetworkProvider {
    
    class func getRequest(forUrl url: URL, completion: @escaping (_ data: Data?, _ error:  NSError?) -> Void) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                completion(nil, error as NSError)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                
                let error = NSError(domain: "", code: 404, userInfo: nil)
                completion(nil, error)
                return
            }
            
            if 200..<300 ~= response.statusCode {
                
                completion(data, nil)
                
            } else {
                
                let error = NSError(domain:"", code:response.statusCode, userInfo:nil)
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    
    private class func processTaskResult(data: Data?, response: URLResponse?, error: Error?) -> (data: Data?, error: NSError?) {
        
        if let error = error {
            return (nil, error as NSError?)
        }
        
        guard let response = response as? HTTPURLResponse else {
            
            let error = NSError(domain: "", code: 404, userInfo: nil)
            return (nil, error)
        }
        
        if 200..<300 ~= response.statusCode {
            
            return (data, nil)
            
        } else {
            
            let error = NSError(domain:"", code:response.statusCode, userInfo:nil)
            return (nil, error)
        }
    }
}
