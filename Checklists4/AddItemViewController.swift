//
//  AddItemViewController.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/5/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - IBOutlet Variables
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
    }
    
    // MARK: - IBAction Methods
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        let newItem = ChecklistItem()
        newItem.text = textField.text! as String
        newItem.checked = false
        
        print(newItem)
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegate Protocol Methods
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButtonItem.isEnabled = (newText.length > 0)
        
        return true
    }

   
}
