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

class DetalheItemViewController: UITableViewController , UITextFieldDelegate{

    @IBOutlet weak var campoTexto: UITextField!
    
    @IBOutlet weak var botaoConcluir: UIBarButtonItem!
    
    var itemEditar : CheckListItem?
    
    weak var delegate:DetalheItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        if let item = itemEditar{
            
            title = "Editar item"
            
            campoTexto.text = item.text
            
            botaoConcluir.enabled = true
        }
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
        
        delegate?.detalheItemViewControllerCancelou(self)
    }
    
    @IBAction func concluir(){
        
        if let item = itemEditar{
            
            item.text = campoTexto.text
            
            delegate?.detalheItemViewController(self, acabouDeEditar: item)
            
        }else{
            
            let item = CheckListItem()
            
            item.text = campoTexto.text
            
            item.checked = false
            
            delegate?.detalheItemViewController(self, acabouDeAdicionar: item)

        }
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

}
