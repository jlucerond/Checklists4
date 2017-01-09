//
//  ListDetailViewController.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/6/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checkListToEdit: Checklist?
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checkListToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            iconName = checklist.iconName
            iconImageView!.image = UIImage(named: iconName)
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - IBAction Methods
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checkListToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
        return nil
        }
    }
    
    // MARK: - Text Field Delegate Methods
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
    // MARK: - Icon Picker View Controller Delegate Method
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: self.iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}
