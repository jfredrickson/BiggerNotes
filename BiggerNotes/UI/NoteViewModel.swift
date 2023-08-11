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

    // Delete a specific note
    func delete(_ note: Note) {
        managedObjectContext.delete(note)
    }

    // Toggle the favorite status of a note
    func toggleFavorite(_ note: Note) {
        note.favorite.toggle()
    }
}
