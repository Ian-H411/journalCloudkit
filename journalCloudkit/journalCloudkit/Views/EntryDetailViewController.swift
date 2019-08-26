//
//  EntryDetailViewController.swift
//  journalCloudkit
//
//  Created by Ian Hall on 8/26/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextField: UITextView!
    
    var landingPad: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entry = landingPad {
            titleTextField.text = entry.title
            bodyTextField.text = entry.bodyText
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if titleTextField.text == "" || bodyTextField.text == "" {return}
        guard let newTitle =  titleTextField.text, let newBody = bodyTextField.text else {return}
        if let entry = landingPad {
            EntryController.sharedInstance.modify(entry: entry, newTitle: newTitle, newBody: newBody)
        } else {
            let newEntry = Entry(with: newTitle, bodyText: newBody)
            EntryController.sharedInstance.save(entry: newEntry) { (success) in
                if success{
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
