//
//  CheckList.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 22/06/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import UIKit

class CheckList: NSObject, NSCoding {
    
    required init(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObjectForKey("Name") as! String
        
        items = aDecoder.decodeObjectForKey("Items") as! [CheckListItem]
        
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        
        super.init()
    }
    
    init(name:String,iconName:String) {
        
        self.name = name
        
        self.iconName = iconName
        
        super.init()
    }
    
    convenience init(name: String) {
        
        self.init(name: name, iconName: "Sem Icone")
    }

    var name = ""
    var items = [CheckListItem]()
    var iconName: String
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: "Name")
        
        aCoder.encodeObject(items, forKey: "Items")
        
        aCoder.encodeObject(iconName, forKey: "IconName")
        
    }
    
    func countUncheckedItems() -> Int{
        
        var count = 0
        for item in items{
            if !item.checked{
                count += 1
            }
        }
        return count
    }

}
