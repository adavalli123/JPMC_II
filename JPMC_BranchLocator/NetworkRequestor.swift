//
//  NetworkRequestor.swift
//  JPMC_BranchLocator
//
//  Created by yashwanth on 11/19/16.
//  Copyright © 2016 srikanth. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkRequestor {
    func getRequest(path: URLRequest, completionHandler: @escaping (Data?, Error?) -> ())
    {
        let task = URLSession.shared.dataTask(with: path as URLRequest, completionHandler: {data, response, error in
            if let error = error {
                
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
                completionHandler(nil, error)
            }
            else {
                completionHandler(data, nil)
            }
        })
        task.resume()
    }
    
    func getLocation(lat: Double, long: Double, completionhandler:@escaping (([LocationModel]?, [AnnotationModel]?, Error?) -> Void)) {
        var fullPath = "https://m.chase.com/PSRWeb/location/list.action?lat=\(lat)&lng=\(long)"
        fullPath = fullPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let request = URLRequest(url: URL(string: fullPath)!)
        self.getRequest(path: request) { (data, error) in
            
            if let error = error {
                print("Error:\n\(error)")
                completionhandler(nil, nil, error)
            }
            
            do
            {
                guard let responseData : [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] else {
                    return
                }
                
                guard let resultArray = responseData["locations"] else {
                    return
                }
                let locationArray = resultArray as! [[String: AnyObject]]
                var models = [LocationModel]()
                var annoModels = [AnnotationModel]()
                for model in locationArray
                {
                    let info = LocationModel(dict: model)
                    models.append(info)
                    let lat = Double(info.lat!)
                    let lng = Double(info.lng!)
                    let detailDictonary = ["address": info.address!,
                                            "city":model["city"],
                                            "state": model["state"],
                                            "zip": model["zip"],
                                            "phone":model["phone"],
                                            "distance": model["distance"],
                                            "atm": model["atm"],
                                            "lobbyHours": model["lobbyHrs"],
                                            "driveUpHours": model["driveUpHrs"],
                                            "locationType": info.locType,
                                            "type": model["type"],
                                            "label":model["label"],
                                            "access":model["access"],
                                            "services":model["services"],
                                            "atms":model["atms"]] as [String : Any]
                    
                    let coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat!),longitude: CLLocationDegrees(lng!))
                    let annotation = AnnotationModel(title: info.address!, subtitle: info.label!, icon: info.locType, infoDict: detailDictonary as [String : AnyObject], coordinate: coordinate)
                    annoModels.append(annotation)
                }
                completionhandler(models, annoModels, nil)
            }
            catch let responseDataError {
                completionhandler(nil, nil, responseDataError)
            }
        }
        
    }
}
