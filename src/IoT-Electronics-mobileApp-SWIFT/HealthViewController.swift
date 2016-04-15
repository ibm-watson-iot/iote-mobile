/* *****************************************************************************
  Copyright (c) 2016 IBM Corporation and other Contributors.

  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html

  Contributors:
  Chungen Kao
  Troy Dugger
  Graeme Fulton
  Sujita Gurung
  Dawn Ahukanna
***************************************************************************** */

import UIKit

class HealthViewController: UIViewController {
    
    var appliance: NSDictionary?
    @IBOutlet weak var labelProblems: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var textDetail: UITextView!
    @IBOutlet weak var imageHealth: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appliance = Global.applianceShowing {
            self.appliance = appliance
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //monitoring core data
        let _context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "getStatusUpdated:",
            name: NSManagedObjectContextObjectsDidChangeNotification,
            object: _context)
        
        // Set the navigation title
        if let applianceName = appliance!["name"] as? String {
            self.navigationController!.visibleViewController!.title = applianceName.characters.count > 0 ? applianceName : appliance!["applianceID"] as? String
        } else {
            self.navigationController!.visibleViewController!.title = appliance!["applianceID"] as? String
        }
        updateStatus()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getStatusUpdated(sender : AnyObject) {
        print("Appliance \(appliance!["applianceID"]) gets updated!")
        updateStatus()
    }
    
    
    func updateStatus(){
        
        //get the latest status of the appliance
        let app: [String: AnyObject]=MQTTManager.sharedInstance.getStatusbyId((appliance!["applianceID"] as? String)!)
        
        var messageString: String!
        
        if let _failureType = app["failureType"] as? String {
            if _failureType.characters.count > 0 {
                imageHealth.image = UIImage(named: "Health_appliance_diagnostics_Bad")
                labelStatus.text="Problem"
                messageString = "ERROR FOUND"
                textDetail.text = _failureType
            }
            else { //_failureType=""
                imageHealth.image = UIImage(named: "Health_appliance_diagnostics_Good")
                labelStatus.text="Healthy"
                messageString = "NO PROBLEMS"
                textDetail.text = "Your washing machine is in geat shape. Keep it up!"
            }
        }
        else{
            imageHealth.image = UIImage(named: "Health_appliance_diagnostics_Good")
            labelStatus.text="Healthy"
            messageString = "NO PROBLEMS"
            textDetail.text = "Your washing machine is in geat shape. Keep it up!"
        }
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: messageString, attributes: underlineAttribute)
        labelProblems.attributedText = underlineAttributedString
        
        imageHealth.setNeedsDisplay()
        labelStatus.setNeedsDisplay()
        labelProblems.setNeedsDisplay()
        
    }
    
}