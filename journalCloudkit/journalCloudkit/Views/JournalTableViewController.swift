//
//  JournalTableViewController.swift
//  journalCloudkit
//
//  Created by Ian Hall on 8/26/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.sharedInstance.fetchEntries { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.sharedInstance.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = EntryController.sharedInstance.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = "\(entry.timeStamp)"
        return cell
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = EntryController.sharedInstance.entries[indexPath.row]
            EntryController.sharedInstance.deleteEntry(entryToDelete: entryToDelete) { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let index = tableView.indexPathForSelectedRow{
                if let toDetailVC = segue.destination as? EntryDetailViewController{
                    let objectToSend = EntryController.sharedInstance.entries[index.row]
                    toDetailVC.landingPad = objectToSend
                }
            }
        }
    }
    
    
}
