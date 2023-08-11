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
    @NSManaged public var content: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var created: Date?
    @NSManaged public var modified: Date?
    
    // Human-friendly indicator of whether the note is a favorite or a non-favorite note.
    @objc dynamic var categoryName: String {
        return favorite ? "Favorites" : "Notes"
    }
    
    override public class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        switch key {
        case "categoryName":
            return Set(["favorite"])
        default:
            return super.keyPathsForValuesAffectingValue(forKey: key)
        }
    }
}

extension Note : Identifiable {}
