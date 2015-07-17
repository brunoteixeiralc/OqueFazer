//
//  DataModel.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 14/07/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import Foundation

class DataModel{
    
    var lists = [CheckList]()
    
    var indexOfSelectedCheckList: Int{
        
        get{
            return NSUserDefaults.standardUserDefaults().integerForKey("CheckListIndex")
        }
        
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "CheckListIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init(){
        
        loadCheckListItens()
        registerDefaults()
        handleFirstTime()
    }
    
    func registerDefaults(){
        
        let dictionary = ["CheckListIndex": -1,
                          "FirstTime":true]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func documentDirectory()->String{
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        
        return paths[0]
    }
    
    func dataFilePath() ->String{
        
        return documentDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func salvarCheckList(){
        
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(lists, forKey: "CheckLists")
        
        archiver.finishEncoding()
        
        data.writeToFile(dataFilePath(), atomically: true)
        
    }
    
    func loadCheckListItens(){
        
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            
            if let data = NSData(contentsOfFile: path){
                
                let unarchive = NSKeyedUnarchiver(forReadingWithData: data)
                
                lists = unarchive.decodeObjectForKey("CheckLists") as! [CheckList]
                
                unarchive.finishDecoding()
                
            }
            
            sortChecklists()
        }
        
    }
    
    func handleFirstTime(){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let firstTime = userDefaults.boolForKey("FirstTime")
        
        if firstTime{
        
            let checkList = CheckList(name: "Sua Lista")
            
            lists.append(checkList)
            
            indexOfSelectedCheckList = 0
            
            userDefaults.setBool(false, forKey: "FirstTime")
        }
        
    }
    
    func sortChecklists() {
        
        lists.sort({ checklist1, checklist2 in return
        checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending })
    }
    
}
