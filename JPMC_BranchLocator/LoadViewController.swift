//
//  ViewController.swift
//  JPMC_BranchLocator
//
//  Created by yashwanth on 11/19/16.
//  Copyright © 2016 srikanth. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func navToBranch(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

