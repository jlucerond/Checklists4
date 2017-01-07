//
//  Checklist.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/6/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
//    // Initializer Methods
//    override init() {
//        super.init()
//    }
    
    // NSCoding Protocol Methods
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }

}
