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

class StatusViewController: UIViewController {
    
    var appliance: NSDictionary?
    
    @IBOutlet weak var buttonControl: UIButton!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var cycleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appliance = Global.applianceShowing {
            self.appliance = appliance
        }
        
        buttonControl.layer.cornerRadius = 5.0
        buttonControl.titleLabel?.textColor = UIColor.blackColor()
        buttonControl.layer.backgroundColor = UIColor.cyanColor().CGColor
        buttonControl.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
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
        if let applianceName = self.appliance!["name"] as? String {
            self.navigationController!.visibleViewController!.title = applianceName.characters.count > 0 ? applianceName : appliance!["applianceID"]as? String
        } else {
            self.navigationController!.visibleViewController!.title = appliance!["applianceID"] as? String
        }
        
        updateStatus()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBAction func onClickButtonCmd(sender: AnyObject) {
        
        if appliance!["applianceID"]==nil || (appliance!["applianceID"] as? String == "") {
            return
        }
        
        if buttonControl.titleLabel?.text=="Start wash" {
            MQTTManager.sharedInstance.sendCommand(appliance!["applianceID"] as! String, applianceType: "washingMachine", cmd: "startWashing")
        }
        else if buttonControl.titleLabel?.text=="Stop wash"{
            MQTTManager.sharedInstance.sendCommand(appliance!["applianceID"] as! String, applianceType: "washingMachine", cmd: "stopWashing")
        }
        else {
            //do nothing
        }
        
    }
    
    func getStatusUpdated(sender : AnyObject) {
        print("Appliance \(appliance!["applianceID"]) gets updated!")
        updateStatus()
    }
    
    
    func updateStatus(){
        
        //get the latest status of the appliance
        let app: [String: AnyObject]=MQTTManager.sharedInstance.getStatusbyId((appliance!["applianceID"] as? String)!)

        if let _cycle=app["currentCycle"] as? String {
            cycleLabel.text=_cycle
            switch _cycle {
            
            case "End", "Stopped", "Empty":
                imageStatus.image = UIImage(named: "Status_appliance_Empty")
            case "Fill", "Filling":
                imageStatus.image = UIImage(named: "Status_appliance_Fill")
            case "Litespin", "Litespinning":
                imageStatus.image = UIImage(named: "Status_appliance_SpinLite")
            case "Soak", "Soaking":
                imageStatus.image = UIImage(named: "Status_appliance_Soak")
            case "Spin", "Spinning":
                imageStatus.image = UIImage(named: "Status_appliance_Spin")
            case "Drain", "Draining", "Drainning": 
                imageStatus.image = UIImage(named: "Status_appliance_Drain")
            case "Wash":
                imageStatus.image = UIImage(named: "Status_appliance_SpinLite")
            case "Rinse":
                imageStatus.image = UIImage(named: "Status_appliance_Soak")
            default:
                imageStatus.image = UIImage(named: "Status_appliance_Empty")
            }
        }
        else {
            buttonControl.setTitle("Appliance status unavailable!!", forState: .Normal)
            buttonControl.enabled = false
        }
        
        
        //configure for control button (by status: Ready, Working, Stopped, Failure
        if let _status=app["status"] as? String {
            buttonControl.enabled = true
            switch _status {
            case "Ready", "Stopped":
                buttonControl.enabled = true
                buttonControl.setTitle("Start wash", forState: .Normal)
            case "Working":    //don't have this cycle for experimental
                buttonControl.enabled = true
                buttonControl.setTitle("Stop wash", forState: .Normal)
            case "Failure": //don't have this cycle for experimental
                buttonControl.enabled = false
                buttonControl.setTitle("Appliance is unavailable!!", forState: .Normal)
            default:
                buttonControl.enabled = false
                buttonControl.setTitle("Appliance is unavailable!!", forState: .Normal)
            }
        }
        else {
            buttonControl.enabled = false
            buttonControl.setTitle("Appliance is unavailable!!", forState: .Normal)
        }
        
        imageStatus.setNeedsDisplay()
        buttonControl.setNeedsDisplay()
    }
    
    
}