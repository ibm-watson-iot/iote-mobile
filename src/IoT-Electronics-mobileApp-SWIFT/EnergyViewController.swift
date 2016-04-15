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

class EnergyViewController: UIViewController {

    @IBOutlet weak var energyText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = String(UnicodeScalar(176))
        
        energyText.text="Try using your washing machine at 9 pm GMT to save money on your energy bill. \n\nUse a cold water or 30\(s)C cycle where possible. It's only for particularly dirty clothes, bad stains or underwear that are likely to need warmer temperatures. \n\nUse a high spin speed so clothes come out of the washing machine almost dry, with little need for tumble drying."
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let applianceName = Global.applianceShowing!["name"] as? String {
            self.navigationController!.visibleViewController!.title = applianceName.characters.count > 0 ? applianceName : Global.applianceShowing!["applianceID"] as? String
        } else {
            self.navigationController!.visibleViewController!.title = Global.applianceShowing!["applianceID"] as? String
        }
    }

}
