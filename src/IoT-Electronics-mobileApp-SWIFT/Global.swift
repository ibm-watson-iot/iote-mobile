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

struct Global {
    static var QRCodeString:String=""
    static var userID: String = ""
    static var userDisplayName: String = ""
    static var applianceShowing: NSDictionary?
    static var applianceAdded: String = ""
    
    static var isApplianceAdded: Bool = false
    
    static func getUserID() -> String {
        if userID != "" {
            return self.userID
        } else {
            if let userIDFromDefaults = NSUserDefaults.standardUserDefaults().valueForKey("userID") as? String {
                if userIDFromDefaults == "" {
                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.customAuth.showSecureTextEntryAlert()
                    return self.userID
                } else {
                    self.userID = userIDFromDefaults
                    return userIDFromDefaults
                }
            } else {
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                delegate.customAuth.showSecureTextEntryAlert()
                return self.userID
            }
        }
    }
}