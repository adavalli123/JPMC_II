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
    
    var networkRequester: NetworkRequestor = NetworkRequestor()
    
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
        networkRequester.getLocation(lat: lat, long: long) { locationResponse, annotationResponse, error in
            DispatchQueue.main.async {
                for anno in annotationResponse!{
                    let anno = AnnotationModel(title: anno.title!, subtitle: anno.subtitle!, icon: anno.icon!, infoDict: anno.infoDict!,coordinate: anno.coordinate)
                    self.mapView.addAnnotation(anno)
                }
            }
        }
    }
}
