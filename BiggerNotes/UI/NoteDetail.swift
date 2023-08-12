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
    @EnvironmentObject var textSettingsViewModel: TextSettingsViewModel
    @ObservedObject var note: Note

    var body: some View {
        VStack {
            TextView(text: $note.content)
            .onDisappear {
                noteViewModel.save()
                noteViewModel.prune()
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack {}
                .frame(maxWidth: .infinity)
                .background(textSettingsViewModel.useCustomColors ? textSettingsViewModel.backgroundColor : .clear)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                TextSettingsButton()
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
        return NavigationView {
            NoteDetail(note: Note())
                .environmentObject(TextSettingsViewModel())
        }
    }
}
