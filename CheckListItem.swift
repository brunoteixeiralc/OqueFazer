//
//  CheckListItem.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 12/05/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import Foundation

class CheckListItem: NSObject, NSCoding {
    
    required init(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObjectForKey("Text") as! String
        
        checked = aDecoder.decodeBoolForKey("Checked")
        
        super.init()
    }
    
    override init() {
        
        super.init()
    }
    
    var text = ""
    var checked = false
    
    func toggleChecked() {
        
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(text, forKey: "Text")
        
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
}

