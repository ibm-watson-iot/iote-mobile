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
import CoreData

extension Appliances {
        
    @NSManaged var topic: String!
    @NSManaged var key: String!
    @NSManaged var json: String!
    @NSManaged var currentCycle: String?
    @NSManaged var doorOpen: NSNumber?
    @NSManaged var failureType: String?
    @NSManaged var id: String?
    @NSManaged var program: String?
    @NSManaged var status: String?

}
