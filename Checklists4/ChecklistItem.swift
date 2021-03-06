//
//  ChecklistItem.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/4/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    // MARK: - Initializer Methods
    override convenience init() {
        self.init(text: "No Name")
    }
    
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    // MARK: - Deinitialize Methods
    deinit {
        removeNotification()
    }
    
    // MARK: - NSCoding Protocol Methods
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    // MARK: - Helper Methods
    func toggleCheckmark() {
        checked = !checked
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled notification for itemID \(itemID)")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
        print("removed a notification")
    }

}

/*
Now, init methods are special in Swift. Because you just added init?(coder) you also need to add an init() method that takes no parameters. Without this, the app won’t build. You’ll learn more about why soon.
 
 ...
 
 You don’t always need to provide an init method. If your init method doesn’t need to do anything – if there are no instance variables to fill in – then you can leave it out completely and the compiler will provide one for you.
 When you first made ChecklistItem, it didn’t have an init() method either. But now that you’ve added init?(coder) you also have to provide an init() that doesn’t take any parameters.

*/
