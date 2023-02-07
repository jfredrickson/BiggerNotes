//
//  NoteDetail.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct NoteDetail: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject var note: Note

    var body: some View {
        VStack {
            TextView(text: $note.content)
            .onDisappear {
                noteViewModel.save()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                SettingsButton()
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Delete
                Button {
                    noteViewModel.delete(note)
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash")
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
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let note = NoteViewModel(withPersistenceController: .preview).notes.first!
        return NavigationView {
            NoteDetail(note: note)
                .environmentObject(SettingsViewModel())
        }
    }
}
