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
    private let noteController: NSFetchedResultsController<Note>

    @Published private(set) var notes: [Note] = []
    var favoriteNotes: [Note] { get { notes.filter { note in note.favorite } } }
    var nonfavoriteNotes: [Note] { get { notes.filter { note in !note.favorite } } }
    @Published var errorMessage: String?

    override convenience init() {
        self.init(withPersistenceController: PersistenceController.shared)
    }

    init(withPersistenceController persistenceController: PersistenceController) {
        if let errorMessage = persistenceController.errorMessage {
            self.errorMessage = errorMessage
        }
        self.managedObjectContext = persistenceController.container.viewContext
        noteController = NSFetchedResultsController(
            fetchRequest: Note.fetchRequest(),
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "notes"
        )
        super.init()
        noteController.delegate = self
        refresh()
    }

    // Refresh all notes
    private func refresh() {
        do {
            try noteController.performFetch()
            notes = noteController.fetchedObjects ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
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
    func new(_ content: String = "", favorite: Bool = false) -> Note {
        let note = Note(context: managedObjectContext)
        note.id = UUID()
        note.created = Date()
        note.modified = note.created
        note.content = content
        note.favorite = favorite
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
        save()
    }
}

extension NoteViewModel: NSFetchedResultsControllerDelegate {
    // Automatically update the notes state when Core Data detects an update
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedItems = noteController.fetchedObjects {
            notes = fetchedItems
        }
    }
}
