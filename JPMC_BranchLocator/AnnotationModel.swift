//
//  AnnotationModel.swift
//  JPMC_BranchLocator
//
//  Created by yashwanth on 11/19/16.
//  Copyright © 2016 srikanth. All rights reserved.
//

import Foundation
import MapKit

class AnnotationModel: NSObject,MKAnnotation {
    var title:String?
    var subtitle:String?
    var icon:String?
    var infoDict:[String:AnyObject]?
    var coordinate:CLLocationCoordinate2D
    
    init(title: String, subtitle: String, icon: String?,infoDict:[String:AnyObject], coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        super.init()
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.infoDict = infoDict
    }
}
