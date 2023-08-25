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
                                NoteListItem(note: note)
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
                        SettingsButton(title: "App Settings") {
                            AppSettingsSheet()
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if (appSettingsViewModel.newNoteButtonPosition.includesTop) {
                            Button {
                                router.displayNote(noteViewModel.new())
                            } label: {
                                Label("New Note", systemImage: "square.and.pencil")
                            }
                        }
                    }
                }
                .errorAlert(errorMessage: $noteViewModel.errorMessage)

                if (appSettingsViewModel.newNoteButtonPosition.includesBottom) {
                    Button {
                        router.displayNote(noteViewModel.new())
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .accessibility(value: Text("New Note"))
                            .padding()
                            .font(.system(.body).weight(.bold))
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                noteViewModel.prune()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var viewContext = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        NoteList()
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(AppSettingsViewModel())
            .environmentObject(NoteViewModel())
            .environmentObject(Router())
    }
}
