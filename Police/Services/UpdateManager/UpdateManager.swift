//
//  UpdateManager.swift
//  Police
//
//  Created by Riccardo on 28/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class UpdateManager {
    
    class func updatePeriods() {
        
        NetworkProvider.getRequest(forUrl: URLFactory.dateLastUpdated()) { (data, error) in
            if let error = error {
                print(error.debugDescription)
                return
            }
            if let data = data {
                
                UpdateProcessor.updatePeriods(withData: data)
            }
        }
    }
    
    class func updateCrimes(within mapRect: MKMapRect, completion:@escaping (Error?) -> Void) {

        NetworkProvider.getRequest(forUrl: URLFactory.urlForCrimesByArea(mapRect, period: CoreDataProvider.selectedPeriod())) { (data, error) in
            
            if let error = error {
                print(error.debugDescription)
                completion(error)
                return
            }
            
            if let data = data {
                
                UpdateProcessor.updateObjects(ofType: Crime.self, fromData: data, completion: { (updated) in
                    if updated {
                        completion(nil)
                    }
                })
            }
        }
    }
    
    class func updateOutcomes(forCrime crime: Crime, completion: @escaping (Bool) -> Void) {
        
        NetworkProvider.getRequest(forUrl: URLFactory.urlForOutcomes(forCrime: crime.persistentId!)) { (data, error) in
            if error != nil {
                completion(false)
                return
            }
            
            guard let data = data else { completion(false); return }
            
            UpdateProcessor.updateCrimeOutcome(crime, withData: data, completion: { (success) in
                completion(success)
            })
        }
    }
    
    class func updateStopAndSearch(within mapRect: MKMapRect, completion: @escaping (Error?) -> Void) {
        
        NetworkProvider.getRequest(forUrl: URLFactory.urlForStopAndSearchByArea(mapRect, period: CoreDataProvider.selectedPeriod())) { (data, error) in
            if let error = error {
                print(error.debugDescription)
                completion(error)
                return
            }
            
            if let data = data {
                
                UpdateProcessor.updateStopAndSearch(fromData: data, completion: { (updated) in
                    if (updated) {
                        completion(nil)
                    } else {

                        completion(nil)
                        print("Error: no data for this period")
                    }
                })
            }
        }
    }
    
    
    
    class func updateNeighbourhood(withLocation location: CLLocationCoordinate2D, completion: @escaping (Error?, Neighbourhood?) -> Void) {
        
        NetworkProvider.getRequest(forUrl: URLFactory.urlToLocateNeigbourhood(from: location)) { (data, error) in
            
            if let neighbourhoodId = UpdateProcessor.neighbourhoodId(fromData: data) {
                
                if let neighbourhood = CoreDataProvider.neighbourhood(withId: neighbourhoodId.identifier) {
                    
                    completion(nil, neighbourhood)
                    return
                }
                
                downloadDataForNeighbourhood(neigbourhood: neighbourhoodId, completion: { (dataArray, error) in
                    if let error = error {
                        print(error)
                        completion(error, nil)
                        return
                    }
                    
                    if let dataArray = dataArray {
                        
                        UpdateProcessor.updateNeighbourhood(withDataArray: dataArray, identifier: neighbourhoodId.identifier, completion: { (updated, neighbourhood)  in
                            completion(nil, neighbourhood)
                            return
                        })
                    } else {
                        print("something went wrong updating neighbourhood")
                        completion(nil, nil)
                    }
                })
            }
        }
    }
    
    
    private class func downloadDataForNeighbourhood(neigbourhood: (force: String, identifier: String), completion: @escaping ([Data]? , Error?) -> Void ) {
        
        var urls: [URL] = URLFactory.allUrlsForNeighbouhood(neigbourhood)
        var neighbourhoodData: [Data] = []
        
        func downloadNext() {
            
            if urls.count == 0 {
                
                completion(neighbourhoodData, nil)
                return
                
            } else {
                
                NetworkProvider.getRequest(forUrl: urls.removeFirst(), completion: { (data, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    if let data = data {
                        neighbourhoodData.append(data)
                    } else {
                        return
                    }
                    
                    downloadNext()
                })
            }
        }
        downloadNext()
    }
}
