//
//  NoteList.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI
import CoreData

struct NoteList: View {
    @EnvironmentObject var appSettingsViewModel: AppSettingsViewModel
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var router: Router
    @State private var refreshId = UUID()

    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                NoteListSection(notes: noteViewModel.favoriteNotes, sectionHeaderText: "Favorites", sectionHeaderIcon: "star.fill", expanded: $appSettingsViewModel.expandFavoritesSection)
                NoteListSection(notes: noteViewModel.nonfavoriteNotes, sectionHeaderText: "Notes", sectionHeaderIcon: "note.text", expanded: $appSettingsViewModel.expandNotesSection)
            }
            .task {
                noteViewModel.prune()
            }
            .navigationBarTitle("Notes")
            .navigationDestination(for: Note.self) { note in
                NoteDetail(note: note, parentRefreshId: $refreshId)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    AppSettingsButton()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        router.displayNote(noteViewModel.new())
                    } label: {
                        Label("New Note", systemImage: "square.and.pencil")
                    }
                }
            }
            .id(refreshId)
            .errorAlert(errorMessage: $noteViewModel.errorMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteList()
            .environmentObject(AppSettingsViewModel())
            .environmentObject(NoteViewModel(withPersistenceController: .preview))
            .environmentObject(Router())
    }
}
