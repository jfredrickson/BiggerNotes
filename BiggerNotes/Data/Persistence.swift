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
            newNote.trashed = (i % 5 == 0)
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
        #endif // DEBUG

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        var errorMessage: String?

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                errorMessage = error.localizedDescription
            }
        })

        self.errorMessage = errorMessage
    }
    
    func resetData() {
        let context = container.viewContext
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let _ = try? container.persistentStoreCoordinator.execute(batchDeleteRequest, with: context)
        }
    }
    
    func loadScreenshotData() {
        let viewContext = self.container.viewContext
        let strings = [
            "Hello! I'm deaf, we can type to each other here.",
            "The quick brown fox jumped over the lazy dog.",
            "I'd like a large iced tea, please."
        ]
        for i in 0..<strings.count {
            let newNote = Note(context: viewContext)
            newNote.id = UUID(uuidString: "00000000-0000-0000-0000-00000000000\(i)")
            newNote.content = strings[i]
            newNote.created = Date.now
            newNote.modified = newNote.created
            newNote.favorite = (i == 0)
            newNote.trashed = false
        }
        do {
            try viewContext.save()
        } catch {
            // Unhandled error is OK here since this is only for screenshots.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
