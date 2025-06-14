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
    @FocusState var isEditing: Bool

    var body: some View {
        VStack {
            TextView(text: $note.content)
                .font(textSettingsViewModel.uiFont)
                .textColor(textSettingsViewModel.uiTextColor)
                .backgroundColor(textSettingsViewModel.uiBackgroundColor)
                .onDisappear { noteViewModel.save() }
                .focused($isEditing)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Text Settings
                SettingsButton(showingSheet: $router.showingTextSettings, title: "Text Settings", systemImage: "textformat.size") {
                    TextSettingsSheet()
                }
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
                .environmentObject(Router())
        }
    }
}
