//
//  AccountViewController.swift
//  IoT-Electronics-mobileApp-SWIFT
//
//  Created by Conrad Kao on 3/3/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func deleteApplianceAction(sender: AnyObject) {
        if let appliance = Global.applianceShowing {
            if let applianceID = appliance["applianceID"] as? String {
                
                //TODO: provide callback to determine if delete succeeded
                API.deleteApplianceFromUser(applianceID)
                
                // if the appliance just added was deleted, then
                // clear global indicator
                if (Global.applianceAdded == applianceID) {
                    Global.applianceAdded = ""
                }
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Set the navigation title
        if let applianceName = Global.applianceShowing!["name"] as? String {
            self.navigationController!.visibleViewController!.title = applianceName.characters.count > 0 ? applianceName : Global.applianceShowing!["applianceID"] as? String
        } else {
            self.navigationController!.visibleViewController!.title = Global.applianceShowing!["applianceID"] as? String
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
