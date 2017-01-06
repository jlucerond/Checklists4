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

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checkListToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checkListToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
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
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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
}
