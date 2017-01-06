//
//  AllListsViewController.swift
//  Checklists4
//
//  Created by Joe Lucero on 1/6/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    var lists: [Checklist]
    
    // MARK: - Initializer Methods
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        
        super.init(coder: aDecoder)

        var list = Checklist(name: "birthdays")
        lists.append(list)
        
        list = Checklist(name: "groceries")
        lists.append(list)
        
        list = Checklist(name: "apps")
        lists.append(list)
        
        list = Checklist(name: "to do")
        lists.append(list)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let checklist = lists[indexPath.row]
        
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: nil)
    }

    // MARK: - Helper methods
    func makeCell (for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default,
                                       reuseIdentifier: cellIdentifier)
        }
    }

}
