//
//  CustomAuth.swift
//  IoT-Electronics-mobileApp-SWIFT
//
//  Created by Conrad Kao on 3/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

var currentContext:IMFAuthenticationContext?

class CustomAuth:NSObject, IMFAuthenticationDelegate {
    
    let logger = IMFLogger(forName: "IoT4e")
    
    func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationChallenge challenge: [NSObject : AnyObject]!) {
        currentContext = context
        logger.logInfoWithMessages("didReceiveAuthenticationChallenge")
        showSecureTextEntryAlert()
    }
    
    func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationFailure userInfo: [NSObject : AnyObject]!) {
        logger.logErrorWithMessages("custom authentication context failure")
    }
    
    
    func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationSuccess userInfo: [NSObject : AnyObject]!) {
        logger.logInfoWithMessages("Custom authentication context sucess")
    }
    
    func showSecureTextEntryAlert() {
        var usernameTextField:UITextField?
        var passwordTextField:UITextField?
        var vc: UIViewController?
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            vc = topController
        }
        else{
            let window:UIWindow?? = UIApplication.sharedApplication().delegate?.window
            vc = window!!.rootViewController!
        }
        
        let title = NSLocalizedString("IBM IoT for Electronics", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: "This sample login demonstrates custom single sign-on capability. For this demo, you can enter any values or none at all to connect and use the app.", preferredStyle: .Alert)
        
        // Add the text field for the secure text entry.
        alertController.addTextFieldWithConfigurationHandler { textField in
            usernameTextField = textField
            usernameTextField!.placeholder = NSLocalizedString("username", comment: "")
            usernameTextField!.secureTextEntry = false
        }
        
        // Add the text field for the secure text entry.
        alertController.addTextFieldWithConfigurationHandler { textField in
            passwordTextField = textField
            passwordTextField?.placeholder = NSLocalizedString("password", comment: "")
            passwordTextField?.secureTextEntry = true
        }
        
        if let storedUserID = NSUserDefaults.standardUserDefaults().valueForKey("userID") as? String {
            usernameTextField!.text = storedUserID
        }
        
        // Create the actions.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            self.logger.logInfoWithMessages("The \"Secure Text Entry\" alert's cancel action occured.")
            self.showSecureTextEntryAlert()
        }
        
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .Default) { action in
            self.logger.logInfoWithMessages("Submitting auth...")
            self.logger.logInfoWithMessages("u:\(usernameTextField!.text)")
            currentContext?.submitAuthenticationChallengeAnswer(["username":usernameTextField!.text!, "password":passwordTextField!.text!])
            Global.userID = usernameTextField!.text!
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        vc!.presentViewController(alertController, animated: true, completion: nil)
    }
}
