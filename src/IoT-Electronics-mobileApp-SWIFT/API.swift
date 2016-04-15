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

import Foundation

struct API {
    
    static let logger = IMFLogger(forName: "IoT4e")
    
    
    //MCA User authentication
    
    static func initializeMCA (){
        
        setNSUserDefaultsValues()
        
        print("Intializing IMFCLient")
        
        //initialize the Mobile Client Access Client SDK
        let appGUID = NSUserDefaults.standardUserDefaults().stringForKey("appGUID")
        let appRoute = NSUserDefaults.standardUserDefaults().stringForKey("appRoute")
        IMFClient.sharedInstance().initializeWithBackendRoute(appRoute, backendGUID: appGUID)
        
        /*Authentication is required to connect to backend services, register the auth method to MCA*/
        let customAuthenticationRealm = NSUserDefaults.standardUserDefaults().stringForKey("customAuthenticationRealm")
        IMFClient.sharedInstance().registerAuthenticationDelegate(CustomAuth(), forRealm: customAuthenticationRealm)

        authenticateUser()
    }
    
    
    static func authenticateUser() {
        if checkIMFClient() && checkAuthenticationConfig(){
            getAuthToken()
        }
    }
    
    static func getAuthToken() {
        let authManager = IMFAuthorizationManager.sharedInstance()
        authManager.obtainAuthorizationHeaderWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
            var errorMsg: String
            if error != nil {
                errorMsg = "Error obtaining Authentication Header.\nCheck Bundle Identifier and Bundle version string, short in Info.plist match exactly to the ones in MCA, or check the applicationId in bluelist.plist\n\n"
                if let responseText = response?.responseText {
                    errorMsg += "\(responseText)\n"
                }
                if let errorDescription = error?.userInfo.description {
                    errorMsg += "\(errorDescription)\n"
                }
                
                self.invalidAuthentication(errorMsg)
            } else {
                //lets make sure we have an user id before transitioning, IMFDataManager needs this for permissions
                if let userIdentity = authManager.userIdentity as NSDictionary?
                {
                    if let userid = userIdentity.valueForKey("id") as! String? {
                        Global.userID = userid;
                        Global.userDisplayName = userIdentity.valueForKey("displayName") as! String
                        NSUserDefaults.standardUserDefaults().setValue(Global.userID, forKey: "userID")
                        NSUserDefaults.standardUserDefaults().setValue(Global.userDisplayName, forKey: "userDisplayName")
                        let mainApplication = UIApplication.sharedApplication()
                        if let delegate = mainApplication.delegate as? AppDelegate {
                            delegate.isUserAuthenticated = true
                        }
                    } else {
                        self.invalidAuthentication("Valid Authentication Header and userIdentity, but id not found")
                    }
                } else {
                    self.invalidAuthentication("Valid Authentication Header, but userIdentity not found. You have to configure one of the methods available in Advanced Mobile Service on Bluemix, such as Facebook, Google, or Custom ")
                }
            }
        }
    }
    
    static func checkIMFClient() -> Bool{
        let imfclient = IMFClient.sharedInstance()
        let route = imfclient.backendRoute
        let uid = imfclient.backendGUID
        
        if route == nil || route.isEmpty {
            invalidAuthentication("Invalid Route.\n Check applicationRoute settings")
            return false
        }
        if uid == nil || uid.isEmpty {
            invalidAuthentication("Invalid UID.\n Check applicationId settings")
            return false
        }
        return true
    }
    
    static func checkAuthenticationConfig() -> Bool {
        
        if isCustomConfigured() {
            print("Custom Login")
            return true
        }
        
        invalidAuthentication("Authentication is not configured in bliemix.plist. You have to configure bluemix.plist with the same Authentication method configured on Bluemix such as Facebook, Google, or Custom. Check the README.md file for more instructions")
        return false
    }
    
    static func isCustomConfigured() -> Bool {
        
        let customAuthenticationRealm = NSUserDefaults.standardUserDefaults().stringForKey("customAuthenticationRealm")
        
        if customAuthenticationRealm!.isEmpty {
            return false
        }
        return true
    }

    static func invalidAuthentication(message:String){
        self.clearKeychain()
    }
    
    
    
    // MCA helper functions for debuging
    static func deleteAllKeysForSecClass(secClass: CFTypeRef) {
        let dict = NSMutableDictionary()
        let kSecAttrAccessGroupSwift = NSString(format: kSecClass)
        dict.setObject(secClass, forKey: kSecAttrAccessGroupSwift)
        SecItemDelete(dict)
    }
    
    
    //MCA
    static func clearKeychain () {
        deleteAllKeysForSecClass(kSecClassIdentity)
        deleteAllKeysForSecClass(kSecClassGenericPassword)
        deleteAllKeysForSecClass(kSecClassInternetPassword)
        deleteAllKeysForSecClass(kSecClassCertificate)
        deleteAllKeysForSecClass(kSecClassKey)
    }
    
    
    
    static func setNSUserDefaultsValues (){

        //MCA settings for custom auth
        if userDefaults.stringForKey("customAuthenticationRealm") == nil || userDefaults.stringForKey("customAuthenticationRealm") == "" {
        userDefaults.setValue("myRealm", forKey: "customAuthenticationRealm")
        }
        
    }
    

    
    
    // Appliance Registeration
    static func setApplianceToUser(dictionary: NSDictionary, callback: ((Bool, String) -> Void)?) {
        var isSuccess: Bool = true
        var errorMessage: String = ""
        
        let requestPath = IMFClient.sharedInstance().backendRoute + "/appliances"
        let request = IMFResourceRequest(path: requestPath, method: "POST");
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
        let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        request.setHTTPBody(jsonData)
        
        print("POST to \(requestPath) with JSON:\(jsonString)")
        
        request.sendWithCompletionHandler { (response, error) -> Void in
            if (nil != error){
                isSuccess=false
                NSLog("Error :: %@", error.description)
                errorMessage = error.description
            } else {
                NSLog("Response :: %@", response.responseText)
                NSLog("%@", IMFAuthorizationManager.sharedInstance().userIdentity)
                NSUserDefaults.standardUserDefaults().setValue(true, forKey: "returningUserKey")
            }
            if let method = callback {
                method(isSuccess, errorMessage)
            }
        }
    }
  
    
    static func deleteApplianceFromUser(applianceID: String) -> Bool{
        
        var isSuccess: Bool = true
        
        let requestPath = IMFClient.sharedInstance().backendRoute + "/appliances/" + Global.userID + "/" + applianceID
        print("DELETE to " + requestPath)
        
        let request = IMFResourceRequest(path: requestPath, method: "DELETE");
        request.sendWithCompletionHandler { (response, error) -> Void in
            if (nil != error){
                isSuccess=false
                NSLog("Error :: %@", error.description)
            } else {
                NSLog("Response :: %@", response.responseText)
                NSLog("%@", IMFAuthorizationManager.sharedInstance().userIdentity)
            }
        };
        
        return isSuccess
    }
    
    static func getAppliancesForUser(callback: ( (AnyObject) -> Void)? ) {
        let requestPath = IMFClient.sharedInstance().backendRoute + "/appliances/" + Global.getUserID()
        let request = IMFResourceRequest(path: requestPath, method: "GET");
        print("GET to " + requestPath)
        
        request.sendWithCompletionHandler { (response, error) -> Void in
            if (nil != error){
                NSLog("Error :: %@", error.description)
                callback?([])
            } else {
                NSLog("Response :: %@", response.responseText)
                NSLog("%@", IMFAuthorizationManager.sharedInstance().userIdentity)
                callback?(response.responseJson)
            }
        }
    }
    
    static func getSpecificApplianceForUser(applianceID: String) {
        let requestPath = IMFClient.sharedInstance().backendRoute + "/appliances/" + Global.userID + "/" + applianceID
        let request = IMFResourceRequest(path: requestPath, method: "GET");
        print("GET to " + requestPath)
        
        request.sendWithCompletionHandler { (response, error) -> Void in
            if (nil != error){
                NSLog("Error :: %@", error.description)
            } else {
                NSLog("Response :: %@", response.responseText)
                NSLog("%@", IMFAuthorizationManager.sharedInstance().userIdentity)
            }
        }
    }
}