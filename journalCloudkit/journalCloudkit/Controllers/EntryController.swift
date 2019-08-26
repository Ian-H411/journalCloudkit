//
//  EntryController.swift
//  journalCloudkit
//
//  Created by Ian Hall on 8/26/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CloudKit

class EntryController{
    //singleton
    
    static let sharedInstance = EntryController()
    
    //source of truth
    var entries = [Entry]()
    
    let database = CKContainer(identifier:"iCloud.com.IanH411.journalCloudkit").privateCloudDatabase
    
    //CRUD
    
    //MARK: -Create
    
    func save(entry: Entry, completion: @escaping (Bool) -> Void){
        //create record
        let record = CKRecord(entry: entry)
        //acssess the database and save
        database.save(record) { (record, error) in
            if let error = error{
                print(error.localizedDescription)
                print(error)
                completion(false)
                return
            }
            guard let record = record else {completion(false); return}
            guard let entry = Entry(ckRecord: record) else {completion(false); return}
            self.entries.append(entry)
            completion(true)
        }
    }
    
    //MARK: - READ
    
    func fetchEntries(completion: @escaping (Bool) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordEntryKey, predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                print(error)
                completion(false)
                return
            }
            var arrayOfEntries = [Entry]()
            guard let records = records else {completion(false); return}
            for record in records{
                guard let newEntry = Entry(ckRecord: record) else {completion(false); return}
                arrayOfEntries.append(newEntry)
            }
            self.entries = arrayOfEntries
            completion(true)
        }
    }
    
    func deleteEntry(entryToDelete: Entry, completion: @escaping (Bool) -> Void){
        for entry in self.entries{
            if entry == entryToDelete{
                guard let index = self.entries.firstIndex(of: entry) else {completion(false);return}
                self.entries.remove(at: index)
            }
        }
        database.delete(withRecordID: entryToDelete.ckRecordID) { (_, error) in
            if let error = error{
                print(error.localizedDescription)
                print(error)
                completion(false)
            }
            
            completion(true)
        }
    }
    
    func modify(entry: Entry, newTitle: String, newBody: String){
        let newEntry = Entry(with: newTitle, bodyText: newBody)
        let newEntryAsRecord = CKRecord(entry: newEntry)
        let deltionForm = CKModifyRecordsOperation(recordsToSave: [newEntryAsRecord], recordIDsToDelete: [entry.ckRecordID])
        database.add(deltionForm)
    }
    
    
    
}
