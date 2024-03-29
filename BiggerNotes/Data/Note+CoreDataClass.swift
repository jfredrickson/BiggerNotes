//
//  Note+CoreDataClass.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    // Automatically update lastModified if content changed
    public override func willSave() {
        super.willSave()
        if !isDeleted && !changedValues().keys.contains("modified") && changedValues().keys.contains("content") {
            modified = Date()
        }
    }
    
    // Set default values
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        content = ""
        favorite = false
        id = UUID()
        created = Date()
        modified = Date()
        trashed = false
    }
}
