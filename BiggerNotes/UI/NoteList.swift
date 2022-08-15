//
//  NoteList.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI
import CoreData

struct NoteList: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                NoteListSection(notes: noteViewModel.favoriteNotes, sectionHeaderText: "Favorites", sectionHeaderIcon: "star.fill")
                NoteListSection(notes: noteViewModel.nonfavoriteNotes, sectionHeaderText: "Notes", sectionHeaderIcon: "note.text")
            }
            .task {
                noteViewModel.prune()
            }
            .navigationBarTitle("Notes")
            .navigationDestination(for: Note.self) { note in
                NoteDetail(note: note)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        router.displayNote(noteViewModel.new())
                    } label: {
                        Label("New Note", systemImage: "square.and.pencil")
                    }
                }
            }
            .listStyle(.sidebar)
            .errorAlert(errorMessage: $noteViewModel.errorMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteList()
            .environmentObject(NoteViewModel(withPersistenceController: .preview))
            .environmentObject(Router())
    }
}
