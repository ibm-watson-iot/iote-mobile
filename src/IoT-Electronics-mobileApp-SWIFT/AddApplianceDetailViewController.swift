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

class AddApplianceDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var name: String = ""
    var applianceId: String=""
    var serialNo: String = ""
    var model: String = ""
    var make: String = ""
    var dateofpurchase: String = ""
    
    // Screen Sizes
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    @IBOutlet weak var applianceDetailsLabel: UILabel!
    
    @IBOutlet weak var appID: UITextField!
    @IBOutlet weak var appName: UITextField!
    @IBOutlet weak var appSN: UITextField!
    @IBOutlet weak var appMake: UITextField!
    @IBOutlet weak var appModel: UITextField!
    @IBOutlet weak var appDoP: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appSN.text=serialNo
        
        //hide the tab bar
        self.tabBarController?.tabBar.hidden = true
        
        appName.text = name
        appID.text = applianceId
        appSN.text = serialNo
        appMake.text = make
        appModel.text = model
        appDoP.text = dateofpurchase
        
        appID.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        appSN.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        appMake.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        buttonSubmit.layer.cornerRadius = 5.0
        buttonSubmit.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        
        checkComplete()
        
    }
    
    func pressed(sender: UIButton!) {
        performSegueWithIdentifier("secondScene", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //scannerImageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
    }

    private struct Storyboard{
        static let CellIdentifier = "OptionCell"
    }
    
    func saveDataFromFields() {
        name = appName.text!
        applianceId = appID.text!
        serialNo = appSN.text!
        model = appModel.text!
        make = appMake.text!
        dateofpurchase = appDoP.text!
    }
    
    
    func checkComplete(){
        if appID.text! == "" || appSN.text! == "" || appMake.text! == "" {
            
        }
        else {
            
        }
    }
    
    
    func textFieldDidChange(textField: UITextField) {
        checkComplete()
    }
}




