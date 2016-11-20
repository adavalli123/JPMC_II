//
//  DetailViewController.swift
//  JPMC_BranchLocator
//
//  Created by yashwanth on 11/19/16.
//  Copyright © 2016 srikanth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var driverUpHoursTextView: UITextView!
    @IBOutlet weak var lobbyHoursTextView: UITextView!
    @IBOutlet weak var branchPhoneNumberLabel: UILabel!
    @IBOutlet weak var numberOfAtms: UILabel!
    @IBOutlet weak var atmServicesTextView: UITextView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var atmBranchAddressTextView: UITextView!
    var dict = [String:AnyObject]()
    
    var locationDetailModel : AnnotationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpView()
    }
    
    // Set up view with details of ATM/Branch
    func setUpView() {
        
        if let name = dict["label"]
        {
            self.nameLabel.text = name as? String
        }
        if let atms = dict["atms"]
        {
            self.numberOfAtms.text = "\(atms)"
        }
        if let type = dict["type"]
        {
            self.typeLabel.text = "\(type)"
        }
        
        if let driveUpHrs = dict["driveUpHours"] as? [String]
        {
            self.driverUpHoursTextView.text = "\(driveUpHrs)"
        }
        
        if let lobbyHrs = dict["lobbyHours"] as? [String]
        {
            self.lobbyHoursTextView.text = "\(lobbyHrs)"
        }
        
        if let phone = dict["phone"]
        {
            self.branchPhoneNumberLabel.text = "\(phone)"
        }
        
        if let services = dict["services"]
        {
            self.atmServicesTextView.text = "\(services)"
        }
        
        if let bank = dict["bank"]
        {
            self.bankLabel.text = "\(bank)"
        }
        
        var address = ""
        var city = ""
        var state = ""
        var zip = ""
        
        if let locationAddress = dict["address"]
        {
            address = String(describing: locationAddress)
            
        }
        if let locationCity = dict["city"]
        {
            city = String(describing: locationCity)
        }
        if let locationState =  dict["state"]
        {
            state = String(describing: locationState)
        }
        if let locationZip = dict["zip"]
        {
            zip = String(describing: locationZip)
        }
        
        self.atmBranchAddressTextView.text =  address + ", " + city + ", " + state + ", " + zip
        
    }
    
}
