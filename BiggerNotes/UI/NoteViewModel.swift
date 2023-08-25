//
//  NoteViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/1/22.
//

import SwiftUI
import CoreData

class NoteViewModel: NSObject, ObservableObject {
    private let managedObjectContext: NSManagedObjectContext
    @Published var errorMessage: String?

    override convenience init() {
        self.init(withPersistenceController: PersistenceController.shared)
    }

    init(withPersistenceController persistenceController: PersistenceController) {
        if let errorMessage = persistenceController.errorMessage {
            self.errorMessage = errorMessage
        }
        self.managedObjectContext = persistenceController.container.viewContext
        super.init()
    }

    // Save the entire Core Data context if there are any changes
    func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // Delete empty notes
    func prune() {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "content == ''")
        var emptyNotes: [Note] = []
        do {
            emptyNotes = try managedObjectContext.fetch(fetchRequest)
        } catch {
            errorMessage = error.localizedDescription
        }
        emptyNotes.forEach(delete)
    }

    // Create a new note with default values
    func new() -> Note {
        let note = Note(context: managedObjectContext)
        save()
        return note
    }
    
    // Trash a specific note
    func trash(_ note: Note) {
        note.trashed = true
        save()
    }
    
    // Restore a specific note from the trash
    func restore(_ note: Note) {
        note.trashed = false
        save()
    }

    // Delete a specific note
    func delete(_ note: Note) {
        managedObjectContext.delete(note)
        save()
    }
    
    // Delete all notes
    func deleteAll() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Note"))
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do {
            let batchDeleteResult = try managedObjectContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            if let result = batchDeleteResult?.result {
                let deletedNotes = [NSDeletedObjectsKey: result]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedNotes, into: [managedObjectContext])
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Toggle the favorite status of a note
    func toggleFavorite(_ note: Note) {
        note.favorite.toggle()
    }
    
    // Generate some test data for development
    func generateTestData() {
        let strings = [
            "Hello, world",
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            "012345678901234567890123456789012345678901234567890123456789"
        ]
        for i in 0..<10 {
            let newNote = new()
            newNote.content = strings[Int.random(in: 0...2)]
            newNote.favorite = (i % 3 == 0)
        }
        save()
    }
}
