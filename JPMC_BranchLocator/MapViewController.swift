//
//  MapViewController.swift
//  JPMC_BranchLocator
//
//  Created by yashwanth on 11/19/16.
//  Copyright © 2016 srikanth. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var long: Double?
    var lat: Double?
    var detailDictonary = [String: Any]()
    var annotationList: [AnnotationModel]?
    var locationList: [LocationModel]?
    var searchString:String?
    let geoCoder = CLGeocoder()
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .follow
        navigationCustomeTitle(color: UIColor.black, title: "BRANCHES", fontSize: 28.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        clLocationManager.delegate = self
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.startUpdatingLocation()
        
    }
    
    //MARK: Mapkit Delegates
    //customized annotation set image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: AnnotationModel.self) == true {
            let temp = annotation as! AnnotationModel
            let anno = MKAnnotationView(annotation: annotation, reuseIdentifier: "my")
            anno.canShowCallout = true
            anno.image = UIImage(named: temp.icon!)
            anno.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return anno
        }
        return nil
    }
    
    //MARK: CLLocation Delegates
    //detail button func
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let temp = view.annotation as! AnnotationModel
        let anno = temp.infoDict! as [String:AnyObject]
        
        if (control as? UIButton)?.buttonType == UIButtonType.detailDisclosure {
            performSegue(withIdentifier: "showDetail", sender: anno)
        }
    }
    
    lazy var clLocationManager:CLLocationManager = {
        let temp = CLLocationManager()
        return temp
    }()
    
    //getting current user longitude and latitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        lat = locations.last?.coordinate.latitude
        long = locations.last?.coordinate.longitude
        
        if (lat != nil && long != nil){
            getRequestedData(lat: self.lat!, long: self.long!)
            clLocationManager.stopUpdatingLocation()
        }
    }
    
    //passing the data to destination
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailViewController
            vc.dict = sender as! [String:AnyObject]
        }
    }
    
    //MARK: Private Functions
    private func navigationCustomeTitle(color: UIColor, title: String, fontSize: CGFloat) {
        let titleLabel = UILabel()
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize), NSForegroundColorAttributeName: color, NSKernAttributeName : 2.0 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    //Making HTTP GET REQUEST
    private func getRequestedData(lat: Double, long: Double) {
        var fullPath = "https://m.chase.com/PSRWeb/location/list.action?lat=\(lat)&lng=\(long)"
        
        fullPath = fullPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let request = URLRequest(url: URL(string: fullPath)!)
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
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
                    self.detailDictonary = ["address": info.address!,
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
                    let annotation = AnnotationModel(title: info.address!, subtitle: info.label!, icon: info.locType, infoDict: self.detailDictonary as [String : AnyObject], coordinate: coordinate)
                    annoModels.append(annotation)
                }
                self.locationList = models
                self.annotationList = annoModels
                
                DispatchQueue.main.async {
                    self.addAnnotation()
                }
            }
            catch _ as NSError {
                
            }
        })
        task.resume()
    }
    
    //add annotation after get annotation result list
    private func addAnnotation() -> Void{
        for anno in self.annotationList!{
            let anno = AnnotationModel(title: anno.title!, subtitle: anno.subtitle!, icon: anno.icon!, infoDict: anno.infoDict!,coordinate: anno.coordinate)
            mapView.addAnnotation(anno)
        }
    }
}
