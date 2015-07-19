//
//  CheckListItem.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 12/05/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import Foundation
import UIKit

class CheckListItem: NSObject, NSCoding {
    
    required init(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObjectForKey("Text") as! String
        
        checked = aDecoder.decodeBoolForKey("Checked")
        
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        
        super.init()
    }
    
    override init() {
        
        itemID = DataModel.nextCheckListItemID()
        
        super.init()
    }
    
    var text = ""
    
    var checked = false
    
    var dueDate = NSDate()
    
    var shouldRemind = false
    
    var itemID:Int
    
    func toggleChecked() {
        
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(text, forKey: "Text")
        
        aCoder.encodeBool(checked, forKey: "Checked")
        
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
    
    func scheduleNotification(){
        
        if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
            
            let localNotification = UILocalNotification()
            
            localNotification.fireDate = dueDate
            
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            
            localNotification.alertBody = text
            
            localNotification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        }
        
    }
    
}

