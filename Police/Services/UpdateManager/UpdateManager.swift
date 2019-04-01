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
    
    
    class func dataForNeighbourhood(neigbourhood: (force: String, identifier: String), completion: @escaping ([Data]? , Error) -> Void ) {
        
        var urls: [URL] = []

        
    }
    
    class func updateNeighbourhood(withCentre center: CLLocationCoordinate2D, completion: @escaping (Error?) -> Void) {
        
        NetworkProvider.getRequest(forUrl: URLFactory.urlToLocateNeigbourhood(from: center)) { (data, error) in
            
            if let neighbourhoodId = UpdateProcessor.neighbourhoodId(fromData: data) {
                
                var dataToProcess: [Data] = []
                
                NetworkProvider.getRequest(forUrl: URLFactory.urlForNeighbourhood(neighbourhoodId, infotype: .specific), completion: { (neighbourhoodData, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    if let data = neighbourhoodData {
                        dataToProcess.append(data)
                    } else {
                        return
                    }
                    
                    NetworkProvider.getRequest(forUrl: URLFactory.urlForNeighbourhood(neighbourhoodId, infotype: .boudaries), completion: { (boudariesData, error) in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        if let data = boudariesData {
                            dataToProcess.append(data)
                        } else {
                            return
                        }
                        
                        NetworkProvider.getRequest(forUrl: URLFactory.urlForNeighbourhood(neighbourhoodId, infotype: .team), completion: { (teamData, error) in
                            if let error = error {
                                completion(error)
                                return
                            }
                            if let data = teamData {
                                dataToProcess.append(data)
                            } else {
                                return
                            }
                            
                            NetworkProvider.getRequest(forUrl: URLFactory.urlForNeighbourhood(neighbourhoodId, infotype: .events), completion: { (eventData, error) in
                                if let error = error {
                                    completion(error)
                                    return
                                }
                                
                                if let data = eventData {
                                    dataToProcess.append(data)
                                } else {
                                    return
                                }
                                
                                NetworkProvider.getRequest(forUrl: URLFactory.urlForNeighbourhood(neighbourhoodId, infotype: .priorities), completion: { (prioritiesData, error) in
                                    if let error = error {
                                        completion(error)
                                        return
                                    }
                                    
                                    if let data = prioritiesData {
                                        dataToProcess.append(data)
                                    } else {
                                        return
                                    }
                                    
                                    UpdateProcessor.processNeighbourhood(fromData: dataToProcess)
                                    
                                })
                            })
                        })
                    })
                })
            }
        }
    }
}
