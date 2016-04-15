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

class AddApplianceViewController: UIViewController, UINavigationControllerDelegate {
    
    
    var name: String = ""
    var applianceId: String = ""
    var serialNo: String = ""
    var model: String = ""
    var make: String = ""
    var type: String = ""
    var dateofpurchase: String = ""

    @IBOutlet weak var applianceImage: UIImageView!
    
    @IBOutlet weak var buttonQRCode: UIButton!
    @IBOutlet weak var buttonDetail: UIButton!
    @IBOutlet weak var buttonConnect: UIButton!
    
    var isComplete: Bool=false
    var isEnabled: Bool = false
    var isAddSuccessful: Bool = false
    
    // Screen Sizes
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if let navController = self.navigationController {
            navController.navigationBar.tintColor = UIColor.whiteColor()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    override func viewWillAppear(animated: Bool) {
        if let navController = self.navigationController {
            if let vc = navController.visibleViewController {
                vc.title = "Add Appliance"
            }
        }
        super.viewWillAppear(animated)
        
        
        if Global.QRCodeString != "" {
            print("QRCodeString: \(Global.QRCodeString)")
            let fullString = Global.QRCodeString.componentsSeparatedByString(",")
            
            if fullString.count == 6 &&  fullString[0]=="2" {
                applianceId=fullString[1]
                serialNo=fullString[2]
                make=fullString[3]
                model=fullString[4]
                type = fullString[5]
            }
            else{
                applianceId = ""
                serialNo = ""
                model = ""
                make = ""
                type = ""
                
                let alert = UIAlertController(title: "QR code Format Error!", message:"The QR code doesn't provide correct info", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        }
        
        if applianceId.characters.count > 0  && serialNo.characters.count > 0 && make.characters.count > 0 && model.characters.count > 0 {
            isComplete=true
        }
        else {
            isComplete=false
        }
        
        updateScreen()
        
        Global.QRCodeString = ""
    }
    
    
    
    func updateScreen (){
    
        buttonDetail.layer.backgroundColor = (isComplete ? UIColor.greenColor().CGColor : UIColor.redColor().CGColor)
        buttonDetail.setTitle((isComplete ? "Appliance details complete" : "Appliance details incomplete"), forState: .Normal)
        
        buttonConnect.enabled = isComplete
        buttonConnect.layer.cornerRadius = 5.0
        buttonConnect.titleLabel?.textColor = (isComplete ? UIColor.blackColor() : UIColor.lightGrayColor())
        buttonConnect.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        //update image
        switch type {
        case "washingMachine":
            applianceImage.image = UIImage(named: "washing machine")
        default:
            applianceImage.image = UIImage(named: "no image")
        }
    }
    
    @IBAction func onClickConnect(sender: UIButton) {
        
        
        if applianceId.characters.count > 0  && serialNo.characters.count > 0 && make.characters.count > 0 && model.characters.count > 0 {
            
            let dictionary = [
                "userID": Global.getUserID(),
                "name": name,
                "applianceID": applianceId,
                "serialNumber": serialNo,
                "manufacturer": make,
                "model": model,
                "dateOfPurchase": dateofpurchase ]
            API.setApplianceToUser(dictionary) { (status, errorMessage) -> Void in
                    if status {
                        self.isAddSuccessful = true
                        Global.applianceAdded = self.applianceId
                        Global.isApplianceAdded=true
                        self.performSegueWithIdentifier("showAppliancesOverview", sender: sender)
                    } else {
                        
                        //let alert = UIAlertController(title: "Appliance added Failed", message:"status:\(status)\n errorMessage:\(errorMessage)", preferredStyle: .Alert)
                        let alert = UIAlertController(title: "Appliance added Failed", message:"Please try later or contact the technical support.", preferredStyle: .Alert)
                        let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default){ _ in }
                        
                        let skipAction = UIAlertAction(title: "Skip", style: UIAlertActionStyle.Default) {
                            UIAlertAction in
                            self.performSegueWithIdentifier("showAppliancesOverview", sender: sender)
                        }                        
                        alert.addAction(retryAction)
                        alert.addAction(skipAction)
                        self.presentViewController(alert, animated: true){}
                        
                        
                    }
                
            }
        }
        else {
            let alert = UIAlertController(title: "Appliance Details Incomplete!", message:"Please scan the QR code again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }

        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // remove back button text
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        if (segue.identifier == "detailSegue") {
            if let svc = segue.destinationViewController as? AddApplianceDetailViewController {
                svc.name = name
                svc.applianceId = applianceId
                svc.serialNo = serialNo
                svc.model = model
                svc.make = make
                svc.dateofpurchase = dateofpurchase
            }
        }
        if (segue.identifier == "QRCodeSegue") {
            if let svc = segue.destinationViewController as? QRCodeReaderViewController {
                svc.sourceViewController = "AddApplianceViewController"
            }
        }
    }
    
    @IBAction func unwindToParent(segue: UIStoryboardSegue) {
        if let svc = segue.sourceViewController as? AddApplianceDetailViewController {
            svc.saveDataFromFields()
            name = svc.name
            applianceId = svc.applianceId
            serialNo = svc.serialNo
            model = svc.model
            make = svc.make
            dateofpurchase = svc.dateofpurchase
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "unwindFromAddAppliance" {
            if applianceId == "" || serialNo == "" || make == "" {
                return false
            } else {
                return true
            }
        }
        if identifier == "showAppliancesOverview" {
            if isAddSuccessful {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    
    @IBAction func unwindToParentFromQRCodeReaderWithCancel(segue: UIStoryboardSegue) {
        if let svc = segue.sourceViewController as? QRCodeReaderViewController {
            svc.onClickCancel()
                    }
    }
    
}