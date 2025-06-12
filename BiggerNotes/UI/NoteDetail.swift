//
//  NoteDetail.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct NoteDetail: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var textSettingsViewModel: TextSettingsViewModel
    @ObservedObject var note: Note

    var body: some View {
        VStack {
            TextView(text: $note.content)
            .onDisappear {
                noteViewModel.save()
            }
            .background(textSettingsViewModel.useCustomColors ? textSettingsViewModel.backgroundColor.color : .clear)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                SettingsButton(showingSheet: $router.showingTextSettings, title: "Text Settings", systemImage: "textformat.size") {
                    TextSettingsSheet()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Trash
                Button {
                    noteViewModel.trash(note)
                    dismiss()
                } label: {
                    Label("Trash", systemImage: "trash")
                }
                // Favorite
                Button {
                    noteViewModel.toggleFavorite(note)
                } label: {
                    Label("Toggle Favorite",systemImage: note.favorite ? "star.fill" : "star")
                        .foregroundColor(note.favorite ? .yellow : .accentColor)
                }
            }
        }
        .toolbarBackground(textSettingsViewModel.useCustomColors ? .visible : .hidden)
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            NoteDetail(note: NoteViewModel(withPersistenceController: .preview).new())
                .environmentObject(NoteViewModel(withPersistenceController: .preview))
                .environmentObject(TextSettingsViewModel())
        }
    }
}
