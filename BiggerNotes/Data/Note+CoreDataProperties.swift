//
//  Note+CoreDataProperties.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//
//

import Foundation
import CoreData


extension Note {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Note.lastModified, ascending: false)]
        return fetchRequest
    }

    @NSManaged public var content: String
    @NSManaged public var favorite: Bool
    @NSManaged public var id: UUID
    @NSManaged public var lastModified: Date
}

extension Note : Identifiable {}
