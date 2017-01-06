//
//  ChecklistItem.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/4/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func toggleCheckmark() {
        checked = !checked
    }
    
    // MARK: - Initializer Methods
    override init() {
        super.init()
    }
    
    // MARK: - NSCoding Protocol Methods
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
}
