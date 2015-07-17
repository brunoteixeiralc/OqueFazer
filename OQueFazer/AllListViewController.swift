//
//  AllListViewController.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 22/06/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController,ListDetalheItemViewControllerDelegate,UINavigationControllerDelegate {

    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedCheckList
        
        if index != -1 {
            
            if(index >= 0 && index < dataModel.lists.count){
            
                let checklist = dataModel.lists[index]
                performSegueWithIdentifier("MostrarCheckList", sender: checklist)
            
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        cell.textLabel!.text = checklist.name
        
        cell.accessoryType = .DetailDisclosureButton
        
        let count =  checklist.countUncheckedItems()
        
        if checklist.items.count == 0 {
            
            cell.detailTextLabel!.text = "Sem checklist"
            
        }else if count == 0{
            
            cell.detailTextLabel!.text = "Todos os checklist concluídos"
        
        }else{
            
            cell.detailTextLabel!.text = "\(count) item(s) não concluídos"
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.indexOfSelectedCheckList = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        
        performSegueWithIdentifier("MostrarCheckList", sender: checklist)
    }
    
    
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetalheViewController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetalheViewController
        
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        
        controller.itemEditar = checklist
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MostrarCheckList"{
            
            let controller = segue.destinationViewController as! CheckListViewController
            
            controller.checklist = sender as! CheckList
        
        }else if segue.identifier == "AdicionarCheckList"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ListDetalheViewController
            
            controller.delegate = self
            
            controller.itemEditar = nil
        }
    }
    
    func listdetalheItemViewControllerCancelou(controller: ListDetalheViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listdetalheItemViewController(controller: ListDetalheViewController, acabouDeEditar item: CheckList) {
        
//        if let index = find(dataModel.lists, item){
//            
//            let indexPath = NSIndexPath(forRow: index, inSection: 0)
//            
//            if let cell = tableView.cellForRowAtIndexPath(indexPath){
//                
//                cell.textLabel!.text = item.name
//            }
//        }
        
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listdetalheItemViewController(controller: ListDetalheViewController, acabouDeAdicionar item: CheckList) {
        
//        let newIndex = dataModel.lists.count
//        
//        dataModel.lists.append(item)
//        
//        let indexPath = NSIndexPath(forRow: newIndex, inSection: 0)
//        
//        let indexPaths = [indexPath]
//        
//        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        
        dataModel.lists.append(item)
        
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    //Delegate navigationcontroller
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        // === verifica se tem referência ao mesmo objeto
        if viewController === self {
            dataModel.indexOfSelectedCheckList = -1
        }
    }
    
    
    
}
