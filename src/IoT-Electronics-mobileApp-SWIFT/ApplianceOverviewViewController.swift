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

class ApplianceOverviewViewController: UIViewController {
    
    @IBOutlet weak var appliancesTableView: UITableView!
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var welcomeDescriptionLabel: UITextView!
    
    var appliances: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "addTapped:")
        rightBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(32.0)], forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        Global.isApplianceAdded=false
    }
    
    func getStatusUpdated(){
        self.appliancesTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        
        Global.applianceAdded = ""
        
        // refresh the list of appliances
        getAppliances()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //when add button is pressed
    func addTapped(sender: UIBarButtonItem!) {
        let storyboard = UIStoryboard(name: "AddAppliance", bundle: nil)
        var controller = storyboard.instantiateInitialViewController()! as UIViewController
        if controller is UINavigationController {
            controller = (controller as! UINavigationController).viewControllers.first!
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getAppliances() {
        API.getAppliancesForUser() { (someobj) -> Void in
            if let dictionary = someobj as? NSDictionary {
                if var values = dictionary["docs"] as? [NSDictionary] {
                    if values.count > 1 {
                        if Global.applianceAdded != "" {
                            var counter = 0
                            for value in values {
                                if value["applianceID"] as? String == Global.applianceAdded {
                                    if counter > 0 {
                                        swap(&values[counter], &values[0])
                                    }
                                    break
                                }
                                counter++
                            }
                        }
                    }
                    self.appliances = values
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: "returningUserKey")
                    self.shouldHideLabels()
                }
            } else {
                self.appliances = []
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "returningUserKey")
            }
            
            MQTTManager.sharedInstance.restartConnection()
            
            self.appliancesTableView.reloadData()
        }
        
    }
    
    func shouldHideLabels() {
        var hideLables = true
        
        if Global.applianceAdded != "" && appliances.count == 1 {
            hideLables = false
        }
        
        if hideLables {
            welcomeTitleLabel.removeFromSuperview()
            welcomeDescriptionLabel.removeFromSuperview()
        }
    }
    
    func refreshTable(appliances: AnyObject) {
        appliancesTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // remove back button text
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        // check what object initiated segue
        if let tableCell: UITableViewCell = sender as? UITableViewCell {
            // set appliance in Global so screens in tab controller can access
            if let selectedIndex: NSIndexPath! = appliancesTableView.indexPathForCell(tableCell) {
                print(appliances[(selectedIndex?.row)!])
                Global.applianceShowing = appliances[(selectedIndex?.row)!]
            }
        }
    }
    
    @IBAction func unwindFromAddAppliance(segue: UIStoryboardSegue) {
        // TODO: Might need this again as unwinding of add doesn't seem right
        print("I'm here")
    }
}

// MARK: - UITableViewDelegate
extension ApplianceOverviewViewController: UITableViewDelegate {
   
}

// MARK: - UITableViewDataSource
extension ApplianceOverviewViewController: UITableViewDataSource {
    
    // number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if appliances.count > 1 {
            if Global.applianceAdded != "" {
                return 2
            }
        }
        return 1
    }
    
    // number of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if appliances.count > 1 {
            if Global.applianceAdded != "" {
                if section == 0 {
                    return 1
                } else {
                    return appliances.count - 1
                }
            }
        }
        return appliances.count
    }
    
    // titles for sections
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if appliances.count > 1 {
            if Global.applianceAdded != "" {
                if section == 0 {
                    return "Just Added"
                } else {
                    return "Other \(appliances.count - 1) appliances"
                }
            }
        } else if appliances.count == 1 {
            return ""
        }
        
        let newlyaddedString: String = Global.isApplianceAdded ? "(one newly added)":""
        
        return "You have \(appliances.count) appliances \(newlyaddedString)"
    }
    
    // get cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier-appliances"
        let cell = appliancesTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ApplianceTableViewCell
        
        if let name = appliances[indexPath.row]["name"] as? String {
            cell.applianceNameLabel.text = name.characters.count > 0 ? name:appliances[indexPath.row]["applianceID"] as? String
        } else {
            cell.applianceNameLabel.text = appliances[indexPath.row]["applianceID"] as? String
        }
        cell.applianceConnectionLabel.text = appliances[indexPath.row]["userID"] as? String
        cell.applianceStatusLabel.text = appliances[indexPath.row]["model"] as? String
        return cell
    }
    
    // add separator between cells
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let additionalSeparatorThickness = CGFloat(10)
        let additionalSeparator = UIView(frame: CGRectMake(0,
            cell.frame.size.height - additionalSeparatorThickness,
            cell.frame.size.width,
            additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor.whiteColor()
        cell.addSubview(additionalSeparator)
    }
}