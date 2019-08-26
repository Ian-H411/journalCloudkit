//
//  Entry.swift
//  journalCloudkit
//
//  Created by Ian Hall on 8/26/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CloudKit
struct EntryConstants {
    static let RecordEntryKey = "entry"
    static let TitleEntryKey = "title"
    static let BodyKey = "body"
    static let TimeStampKey = "date"
    static let IdentifierKey = "ckRecordId"
}
class Entry: Equatable{
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        if lhs.title == rhs.title,
        lhs.bodyText == rhs.bodyText,
        lhs.timeStamp == rhs.timeStamp,
            lhs.ckRecordID == rhs.ckRecordID{
            return true
        }
        return false
    }
    

    var title: String
    
    var bodyText: String
    
    var timeStamp: Date
    
    var ckRecordID : CKRecord.ID
    
    init(with title: String, bodyText: String, timeStamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
    }
    
}
extension CKRecord{
    convenience init(entry: Entry){
        self.init(recordType: EntryConstants.RecordEntryKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.TitleEntryKey)
        self.setValue(entry.bodyText, forKey:EntryConstants.BodyKey)
        self.setValue(entry.timeStamp, forKey: EntryConstants.TimeStampKey)

        
    }
}
extension Entry{
    convenience init?(ckRecord: CKRecord){
        guard let title = ckRecord[EntryConstants.TitleEntryKey] as? String, let body = ckRecord[EntryConstants.BodyKey] as? String, let timeStamp = ckRecord[EntryConstants.TimeStampKey] as? Date else {return nil}
        self.init(with: title, bodyText: body, timeStamp: timeStamp, ckRecordID: ckRecord.recordID)
    }
}
