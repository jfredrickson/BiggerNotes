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
    
    @SectionedFetchRequest<Bool, Note>(
        sectionIdentifier: \.favorite,
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Note.favorite, ascending: false),
            NSSortDescriptor(keyPath: \Note.modified, ascending: false)
        ]
    )
    var sectionedNotes: SectionedFetchResults<Bool, Note>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(sectionedNotes, id: \.id) { section in
                    Section {
                        ForEach(section, id: \.id) { note in
                            NoteListItem(note: note)
                        }
                    } header: {
                        Text(section.id ? "Favorites" : "Notes")
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
