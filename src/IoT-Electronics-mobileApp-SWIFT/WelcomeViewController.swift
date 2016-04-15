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

class WelcomeViewController: UIViewController {
    
    @IBOutlet var buttonAddAppliance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the
        buttonAddAppliance.layer.cornerRadius = 5.0
        buttonAddAppliance.layer.backgroundColor = UIColor.grayColor().CGColor
        buttonAddAppliance.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //make sure tab bar is displayed
        self.tabBarController?.tabBar.hidden = false
    }
    
}
