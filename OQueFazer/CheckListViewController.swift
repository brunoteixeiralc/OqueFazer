//
//  ViewController.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 08/05/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController,DetalheItemViewControllerDelegate {


    var checklist : CheckList!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem") as! UITableViewCell
            
        let item = checklist.items[indexPath.row]
        
        configuraTextForCell(cell, comCheckListItem: item)
        
        configuraCheckmarkForCell(cell, comCheckListItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        
            let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
        
            configuraCheckmarkForCell(cell, comCheckListItem: item)
        }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPath = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPath, withRowAnimation: .Automatic)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AdicionarItem"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! DetalheItemViewController
            
            controller.delegate = self
            
        }else if segue.identifier == "EditarItem"{
        
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! DetalheItemViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
                controller.itemEditar = checklist.items[indexPath.row]
            }
            
        }
    }
   
    func configuraCheckmarkForCell(cell:UITableViewCell,comCheckListItem item:CheckListItem){
        
            let label = cell.viewWithTag(1001) as! UILabel
        
            label.textColor = view.tintColor
        
            if item.checked{
                
                label.text = "√"
            
            }else{
                
                label.text = ""
            }
                
    }
    
    func configuraTextForCell(cell:UITableViewCell,comCheckListItem item:CheckListItem){
          
          let label = cell.viewWithTag(1000) as! UILabel
        
          label.text = item.text
                    
    }
    
    func detalheItemViewControllerCancelou(controller: DetalheItemViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func detalheItemViewController(controller: DetalheItemViewController, acabouDeAdicionar item: CheckListItem) {
        
        let indexItem = checklist.items.count
        
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: indexItem, inSection: 0)
        
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func detalheItemViewController(controller: DetalheItemViewController, acabouDeEditar item: CheckListItem) {
        
        if let index = find(checklist.items, item){
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                
                configuraTextForCell(cell, comCheckListItem: item)
            }
        }
    
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}




