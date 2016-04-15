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
import CoreData /* Core Data */

class MainViewController: UIViewController {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var getStartButton: UIButton!
    @IBOutlet weak var textAreaWelcome: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartButton.layer.cornerRadius = 6;
        
        if userDefaults.boolForKey("returningUserKey") {
            API.initializeMCA()
            getStartButton.setTitle("Welcome Back", forState: .Normal)
            textAreaWelcome.text = "Tap 'Welcome Back' to see your registered devices and begin using them."
        }
        else {
            getStartButton.setTitle("Get Started", forState: .Normal)
            textAreaWelcome.text = "Hit 'Get Started' to see a quick walkthrough and then register your device and begin using them."

        }
        
        textAreaWelcome.textColor = UIColor.whiteColor()
        textAreaWelcome.textAlignment = NSTextAlignment.Center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func buttonPressedGetStarted(sender: UIButton) {
        
        
        if userDefaults.boolForKey("returningUserKey") {
            Global.getUserID()
            let storyboard = UIStoryboard(name: "ApplianceOverview", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()! as UIViewController
            addChildViewController(controller)
            view.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
        }
        else {
            let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()! as UIViewController
            addChildViewController(controller)
            view.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
        }

        
        
        
        
    }

    
}
