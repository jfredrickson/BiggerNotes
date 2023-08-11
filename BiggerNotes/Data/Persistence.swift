//
//  Persistence.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        let strings = [
            "Hello, world",
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            "012345678901234567890123456789012345678901234567890123456789"
        ]
        for i in 0..<10 {
            let newNote = Note(context: viewContext)
            newNote.id = UUID()
            newNote.content = strings[Int.random(in: 0...2)]
            newNote.created = Date()
            newNote.modified = newNote.created
            newNote.favorite = (i % 3 == 0)
        }
        do {
            try viewContext.save()
        } catch {
            // Unhandled error is OK here since this is only for Xcode previews.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return persistenceController
    }()

    let container: NSPersistentCloudKitContainer
    var errorMessage: String?

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "BiggerNotes")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        #if DEBUG
        do {
            try container.initializeCloudKitSchema(options: [
                //.dryRun,
                //.printSchema
            ])
        } catch {
            let nsError = error as NSError
            self.errorMessage = nsError.localizedDescription
        }
        #endif

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        var errorMessage: String?

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                errorMessage = error.localizedDescription
            }
        })

        self.errorMessage = errorMessage
    }
}
