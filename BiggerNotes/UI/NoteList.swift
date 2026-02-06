//
//  NoteList.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI
import CoreData

// Composite identity for note rows, including favorite status so SwiftUI
// treats favorite changes as structural changes (row replacement) rather
// than state changes (row update). This fixes iOS 26 animation glitches
// where the swipe menu state was preserved during row reordering.
// https://stackoverflow.com/a/79847249
struct NoteRowID: Hashable {
    var objectID: NSManagedObjectID
    var favorite: Bool
}

struct NoteList: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var noteService: NoteService
    @EnvironmentObject var router: Router
    @SceneStorage("recentlyActiveNoteId") var recentlyActiveNoteId: String?
    @State var showUndoTrashSnackbar = false
    
    @SectionedFetchRequest<String, Note>(
        sectionIdentifier: \.categoryName,
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Note.favorite, ascending: false),
            NSSortDescriptor(keyPath: \Note.modified, ascending: false)
        ],
        predicate: NSPredicate(format: "trashed == NO"),
        animation: .default
    )
    var notes: SectionedFetchResults<String, Note>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(notes) { section in
                        Section {
                            ForEach(section) { note in
                                NoteLink(note: note)
                                    // Workaround for iOS 26 list animation glitches
                                    .id(NoteRowID(objectID: note.objectID, favorite: note.favorite))
                            }
                        } header: {
                            Label(section.id, systemImage: section.id == "Favorites" ? "star.fill" : "note.text")
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitle("Notes")
                .navigationDestination(for: Note.self) { note in
                    NoteDetail(note: note)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        SettingsButton(showingSheet: $router.showingAppSettings, title: "App Settings") {
                            AppSettingsSheet()
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if (appSettings.newNoteButtonPosition.includesTop) {
                            Button {
                                router.displayNote(noteService.new())
                            } label: {
                                Label("New Note", systemImage: "square.and.pencil")
                            }
                        }
                    }
                }
                .errorAlert(errorMessage: $noteService.errorMessage)

                if (appSettings.newNoteButtonPosition.includesBottom) {
                    FloatingButton {
                        router.displayNote(noteService.new())
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .accessibility(value: Text("New Note"))
                    }
                    .padding()
                    .offset(CGSize(width: 0, height: showUndoTrashSnackbar ? -60 : 0))
                }
                
                Snackbar(isShowing: $showUndoTrashSnackbar, timeout: 5) {
                    Text("Deleted note.")
                } action: {
                    withAnimation {
                        noteService.restoreRecentlyTrashedNote()
                    }
                    showUndoTrashSnackbar.toggle()
                } actionLabel: {
                    HStack {
                        Image(systemName: "arrow.uturn.backward.circle")
                        Text("Undo")
                    }
                }
                .id(noteService.recentlyTrashedNote)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                noteService.prune()
            }
            .onDisappear {
                showUndoTrashSnackbar = false
            }
            .onChange(of: noteService.recentlyTrashedNote) { trashedNote in
                withAnimation {
                    showUndoTrashSnackbar = (trashedNote != nil)
                }
            }
            .onChange(of: router.path) { newPath in
                // Save/clear note ID whenever navigation changes
                if let currentNote = newPath.last {
                    recentlyActiveNoteId = currentNote.id?.uuidString
                } else {
                    // User returned to NoteList - clear the saved note
                    recentlyActiveNoteId = nil
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    if appSettings.startWithNewNote && router.path.isEmpty {
                        // Start a new note upon app open if that preference is set
                        router.displayNote(noteService.new())
                    } else if router.path.isEmpty {
                        // Only restore navigation when path is empty (fresh launch/state restoration)
                        if let recentlyActiveNoteId, let id = UUID(uuidString: recentlyActiveNoteId) {
                            let context = PersistenceController.shared.container.viewContext
                            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
                            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                            fetchRequest.fetchLimit = 1
                            if let note = try? context.fetch(fetchRequest).first {
                                router.displayNote(note)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct NoteList_Previews: PreviewProvider {
    static var viewContext = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        NoteList()
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(AppSettings())
            .environmentObject(NoteService(withPersistenceController: .preview))
            .environmentObject(Router())
    }
}
