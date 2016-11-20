//
//  LocationModel.swift
//  JPMC_BranchLocator
//
//  Created by yashwanth on 11/19/16.
//  Copyright © 2016 srikanth. All rights reserved.
//

import Foundation

class LocationModel: NSObject {
    
    var lat: String?
    var lng: String?
    
    var locType: String?
    var distance: NSNumber?
    var label: String?
    var address: String?

    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}



