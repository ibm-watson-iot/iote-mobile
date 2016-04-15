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

class ApplianceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var applianceGraphic: UIImageView!
    @IBOutlet weak var gradientForeground: UIImageView!
    
    @IBOutlet weak var applianceNameLabel: UILabel!
    @IBOutlet weak var applianceStatusLabel: UILabel!
    @IBOutlet weak var applianceConnectionLabel: UILabel!
    
    @IBOutlet weak var annotationChevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
