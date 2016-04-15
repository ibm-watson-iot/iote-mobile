//
//  LoginViewController.swift
//  IoT-Electronics-mobileApp-SWIFT
//
//  Created by Conrad Kao on 3/20/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    var userId:String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   @IBAction func buttonPressedSignIn(sender: UIButton) {
        
        API.authenticateUser()
        
    }
    
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    //        //let navVC = segue.destinationViewController as! UINavigationController
    //        //let listTableVC = navVC.topViewController as! ListTableViewController
    //        //listTableVC.userId = self.userId
    //    }
    
    
    
    

}
