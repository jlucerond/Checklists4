//
//  AllListsViewController.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/6/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables
    var dataModel: DataModel!

    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
        
    }

    // MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        
        cell.detailTextLabel!.text = makeDetailTextLabel(for: checklist)
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let checklist = dataModel.lists[indexPath.row]

        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        controller.checkListToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - List Detail View Controller Delegate Methods
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation Controller Delegate Methods
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
            controller.dataModel = self.dataModel
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.checkListToEdit = nil
            controller.delegate = self
        }
    }

    // MARK: - Helper methods
    func makeCell (for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle,
                                       reuseIdentifier: cellIdentifier)
        }
    }
    
    func makeDetailTextLabel (for checklist: Checklist) -> String {
        if checklist.items.count == 0 {
            return "(No Items)"
        } else if checklist.countUncheckedItems() == 0 {
            return "All Done!"
        } else{
            return "\(checklist.countUncheckedItems()) Remaining"
        }
    }
    
}
