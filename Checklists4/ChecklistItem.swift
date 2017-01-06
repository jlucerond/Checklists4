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
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    // MARK: - NSCoding Protocol Methods
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }

}

/*
Now, init methods are special in Swift. Because you just added init?(coder) you also need to add an init() method that takes no parameters. Without this, the app won’t build. You’ll learn more about why soon.
 
 ...
 
 You don’t always need to provide an init method. If your init method doesn’t need to do anything – if there are no instance variables to fill in – then you can leave it out completely and the compiler will provide one for you.
 When you first made ChecklistItem, it didn’t have an init() method either. But now that you’ve added init?(coder) you also have to provide an init() that doesn’t take any parameters.

*/
