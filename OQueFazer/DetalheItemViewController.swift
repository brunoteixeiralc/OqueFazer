//
//  DetalheItemViewController.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 15/05/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import UIKit

protocol DetalheItemViewControllerDelegate: class{
    func detalheItemViewControllerCancelou(controller:DetalheItemViewController)
    func detalheItemViewController(controller:DetalheItemViewController, acabouDeAdicionar item:CheckListItem)
    func detalheItemViewController(controller:DetalheItemViewController, acabouDeEditar item:CheckListItem)
}

class DetalheItemViewController: UITableViewController , UITextFieldDelegate {

    @IBOutlet weak var campoTexto: UITextField!
    
    @IBOutlet weak var botaoConcluir: UIBarButtonItem!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    var itemEditar : CheckListItem?
    
    var dueDate = NSDate()
    
    var dataPickerVisible = false
    
    weak var delegate:DetalheItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        if let item = itemEditar{
            
            title = "Editar item"
            
            campoTexto.text = item.text
            
            botaoConcluir.enabled = true
            
            shouldRemindSwitch.on = item.shouldRemind
                
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    func updateDueDateLabel(){
        
        let formatter = NSDateFormatter()
        
        formatter.dateStyle = .MediumStyle
        
        formatter.timeStyle = .ShortStyle
        
        dueDateLabel.text = formatter.stringFromDate(dueDate)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        campoTexto.becomeFirstResponder()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText:NSString = textField.text
        
        let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        botaoConcluir.enabled = newText.length>0
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        hideDatePicker()
    }
    
    @IBAction func cancelar(){
        
        delegate?.detalheItemViewControllerCancelou(self)
    }
    
    @IBAction func concluir(){
        
        if let item = itemEditar{
            
            item.text = campoTexto.text
            
            item.shouldRemind = shouldRemindSwitch.on
            
            item.dueDate = dueDate
            
            item.scheduleNotification()
            
            delegate?.detalheItemViewController(self, acabouDeEditar: item)
            
        }else{
            
            let item = CheckListItem()
            
            item.text = campoTexto.text
            
            item.shouldRemind = shouldRemindSwitch.on
            
            item.dueDate = dueDate
            
            item.checked = false
            
            item.scheduleNotification()
            
            delegate?.detalheItemViewController(self, acabouDeAdicionar: item)

        }
        
    }
    
    @IBAction func shouldRemindToggle(switchControl : UISwitch){
        
        campoTexto.resignFirstResponder()
        
        if switchControl.on{
            
            let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
        }
        
    }
    
    func showDatePicker(){
        
        dataPickerVisible = true
        
        let indexPathdateRow = NSIndexPath(forRow: 1, inSection: 1)
        
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathdateRow){
            
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        
            tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
            tableView.reloadRowsAtIndexPaths([indexPathdateRow], withRowAnimation: .None)
        
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker){
            
            let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
            
            datePicker.setDate(dueDate, animated: false)
            
        }
        
    }
    
    func hideDatePicker(){
        
        if dataPickerVisible {
            
            dataPickerVisible = false
        
            let indexPathdateRow = NSIndexPath(forRow: 1, inSection: 1)
        
            let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
            if let dateCell = tableView.cellForRowAtIndexPath(indexPathdateRow){
            
                dateCell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
        
        tableView.beginUpdates()
        
            tableView.reloadRowsAtIndexPaths([indexPathdateRow], withRowAnimation: .None)
            
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        tableView.endUpdates()
        
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2{
            
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            
            if cell == nil{
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                
                cell.selectionStyle = .None
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                
                datePicker.tag = 100
                
                cell.contentView.addSubview(datePicker)
                
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
            
            return cell
            
        }else{
            
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        }
    }
    
    func dateChanged(datePicker:UIDatePicker){
        
        dueDate = datePicker.date
        
        updateDueDateLabel()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && dataPickerVisible{
            
            return 3
            
        }else{
            
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2{
            
            return 217
        
        }else{
            
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        campoTexto.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            if !dataPickerVisible{
                
                showDatePicker()
                
            }else{
                
                hideDatePicker()
                
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
       
        if indexPath.section == 1 && indexPath.row == 1 {
            
            return indexPath
            
        }else{
            
            return nil
            
        }
        
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            
        }
        
        return super.tableView(tableView,indentationLevelForRowAtIndexPath: indexPath)
    }
    
    
}
