//
//  IconPickerViewController.swift
//  OQueFazer
//
//  Created by Bruno Corrêa on 16/07/15.
//  Copyright (c) 2015 Bruno Corrêa. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    
    func iconPicker(picker: IconPickerViewController,didPickIcon iconName: String)
    
}

class IconPickerViewController: UITableViewController {
        
    weak var delegate: IconPickerViewControllerDelegate?
        
    let icons = [ "Sem Icone",
            "Compromissos", "Aniversarios", "Tarefas", "Bebidas", "Pastas", "Comidas", "Caixa de entrada","Fotos", "Viagens"]
        
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return icons.count
    
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as! UITableViewCell
        
        let iconName = icons[indexPath.row]
        
        if iconName == "Aniversarios" {
            
            cell.textLabel!.text = "Aniversários"
            
        }else if iconName == "Sem Icone"{
         
            cell.textLabel!.text = "Sem Ícone"
            
        }else{
            
             cell.textLabel!.text = iconName
        }

        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
            
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let delegate = delegate{
            
            let iconName = icons[indexPath.row]
            
            delegate.iconPicker(self, didPickIcon: iconName)
        }
    }
}