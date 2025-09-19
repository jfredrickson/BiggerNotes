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
    @State private var clearTrigger = UUID()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextView(text: $note.content, clearTrigger: $clearTrigger)
                .font(textSettingsViewModel.uiFont)
                .textColor(textSettingsViewModel.uiTextColor)
                .backgroundColor(.clear)
                .background(Color(textSettingsViewModel.uiBackgroundColor).ignoresSafeArea(.all))
                .onDisappear { noteViewModel.save() }
                .focused($isEditing)
            if (isEditing) {
                FloatingButton {
                    isEditing.toggle()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .accessibility(value: Text("Hide keyboard"))
                }
                .padding(.bottom, 8)
                .padding(.trailing)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Text Settings
                SettingsButton(showingSheet: $router.showingTextSettings, title: "Text Settings", systemImage: "textformat.size") {
                    TextSettingsSheet()
                }
                // Favorite
                Button {
                    noteViewModel.toggleFavorite(note)
                } label: {
                    Label("Toggle Favorite",systemImage: note.favorite ? "star.fill" : "star")
                        .foregroundColor(note.favorite ? .yellow : .accentColor)
                }
                Menu {
                    // Erase
                    Button {
                        clearTrigger = UUID()
                    } label: {
                        Label("Erase all text", systemImage: "eraser")
                    }
                    // Delete
                    Button(role: .destructive) {
                        noteViewModel.trash(note)
                        dismiss()
                    } label: {
                        Label("Delete note", systemImage: "trash")
                    }
                } label: {
                    Label("More", systemImage: "ellipsis")
                }
            }
        }
        .ignoresSafeArea(.container, edges: findIgnoredEdges)
    }

    var findIgnoredEdges: Edge.Set {
        // Liquid Glass provides sufficient contrast regardless of custom color
        if #available(iOS 26.0, *) {
            .all
        } else {
            [.leading, .trailing, .bottom]
        }
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
