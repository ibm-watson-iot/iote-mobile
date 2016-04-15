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

class BluemixConfigViewController: UIViewController, UINavigationControllerDelegate {
    
    var orgName: String? = ""
    var appRoute: String? = ""
    var appGUID: String? = ""
    var apiKeyMQTT: String? = ""
    var clientIdMQTT: String? = ""
    var apiTokenMQTT: String? = ""
    var customAuthenticationRealm: String?
    var hostMQTT: String? = ""
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        if Global.QRCodeString != "" {
            let fullString = Global.QRCodeString.componentsSeparatedByString(",")
            
            if fullString.count == 8 &&  fullString[0]=="1" {
                
                orgName = fullString[1]
                userDefaults.setValue(orgName, forKey: "orgName")
                
                appRoute=fullString[2]
                userDefaults.setValue(appRoute, forKey: "appRoute")
                
                appGUID=fullString[3]
                userDefaults.setValue(appGUID, forKey: "appGUID")
                
                apiKeyMQTT=fullString[4]
                userDefaults.setValue(apiKeyMQTT, forKey: "apiKeyMQTT")
                
                apiTokenMQTT=fullString[5]
                userDefaults.setValue(apiTokenMQTT, forKey: "apiTokenMQTT")
                
                clientIdMQTT=fullString[6]
                userDefaults.setValue(clientIdMQTT, forKey: "clientIdMQTT")
                
                hostMQTT=fullString[7]
                userDefaults.setValue(hostMQTT, forKey: "hostMQTT")
                
                if appRoute!.characters.count > 0 && appGUID!.characters.count > 0 {
                    API.initializeMCA()
                }

                Global.QRCodeString = ""
                goNextScreen()
            }
            else{

                orgName = ""
                appRoute = ""
                appGUID = ""
                apiKeyMQTT = ""
                clientIdMQTT = ""
                apiTokenMQTT = ""
                hostMQTT = ""
                
                let alert = UIAlertController(title: "QR code Format Error!", message:"The QR code doesn't provide correct organization info", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}

            }
        }
        
        Global.QRCodeString = ""

    }
    
    override func viewWillDisappear(animated: Bool) {
        
        Global.QRCodeString = ""
        
    }
    
    func goNextScreen(){
        let storyboard = UIStoryboard(name: "AddAppliance", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as UIViewController
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "QRCodeSegueConfig") {
            if let svc = segue.destinationViewController as? QRCodeReaderViewController {
                svc.sourceViewController = "BluemixConfig"
            }
        }
    }

    
    @IBAction func unwindToParentFromQRCodeReaderWithCancel(segue: UIStoryboardSegue) {
        if let svc = segue.sourceViewController as? QRCodeReaderViewController {
            svc.onClickCancel()
        }
    }
    
}
