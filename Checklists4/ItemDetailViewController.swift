//
//  ItemDetailViewController.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/5/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                           didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - IBOutlet Variables
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Variables
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButtonItem.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    // MARK: - IBAction Methods
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dueDate = sender.date
        updateDueDateLabel()
    }
    
    // MARK: - Table View Data Source Protocol Method
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    // MARK: - TableView Delegate Protocol Methods
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            textField.resignFirstResponder()
            
            if datePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    // MARK: - Text Field Delegate Protocol Methods
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButtonItem.isEnabled = (newText.length > 0)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    // MARK: - Helper Methods
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker() {
        if !datePickerVisible {
            datePickerVisible = true
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let dateCell = tableView.cellForRow(at: indexPathDateRow){
                dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
            }
            
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPathDatePicker], with: .fade)
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.endUpdates()
            
            datePicker.setDate(dueDate, animated: false)
        }
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let dateCell = tableView.cellForRow(at: indexPathDateRow){
                dateCell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.endUpdates()
        }
    }
   
}
