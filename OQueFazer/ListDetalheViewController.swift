//
//  ListDetalheViewController.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 22/06/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import UIKit

protocol ListDetalheItemViewControllerDelegate: class{
    func listdetalheItemViewControllerCancelou(controller:ListDetalheViewController)
    func listdetalheItemViewController(controller:ListDetalheViewController, acabouDeAdicionar item:CheckList)
    func listdetalheItemViewController(controller:ListDetalheViewController, acabouDeEditar item:CheckList)
}

class ListDetalheViewController: UITableViewController,UITextViewDelegate,IconPickerViewControllerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var campoTexto: UITextField!
    @IBOutlet weak var botaoConcluir: UIBarButtonItem!
    var itemEditar : CheckList?
    weak var delegate: ListDetalheItemViewControllerDelegate?
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        if let item = itemEditar{
            
            title = "Editar Checklist"
            
            campoTexto.text = item.name
            
            botaoConcluir.enabled = true
            
            iconName = item.iconName
            
        }
        
        iconImageView.image = UIImage(named: iconName)

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
    
    @IBAction func cancelar(){
        
        delegate?.listdetalheItemViewControllerCancelou(self)
    }
    
    @IBAction func concluir(){
        
        if let item = itemEditar{
            
            item.name = campoTexto.text
            
            item.iconName = iconName
            
            delegate?.listdetalheItemViewController(self, acabouDeEditar: item)
            
        }else{
            
            let item = CheckList(name: campoTexto.text, iconName: iconName)
            
            delegate?.listdetalheItemViewController(self, acabouDeAdicionar: item)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 1{
            
            return indexPath
        
        }else{
            
            return nil
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickIcon" {
            
            let controller = segue.destinationViewController as! IconPickerViewController
            
            controller.delegate = self
        }
    }
        
    func iconPicker(picker: IconPickerViewController,didPickIcon iconName: String){
        
        self.iconName = iconName
        
        iconImageView.image = UIImage(named: iconName)
        
        navigationController?.popViewControllerAnimated(true)
 
    }
    

}
