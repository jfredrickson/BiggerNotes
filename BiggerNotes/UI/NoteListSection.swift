//
//  NoteListSection.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/31/22.
//

import SwiftUI

struct NoteListSection: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    var notes: [Note]
    var sectionHeaderText: String
    var sectionHeaderIcon: String
    @Binding var expanded: Bool

    var body: some View {
        Section {
            if (expanded) {
                ForEach(notes, id: \.self) { note in
                    NavigationLink(value: note) {
                        VStack(alignment: .leading) {
                            Text(note.content)
                                .lineLimit(1)
                            Text(dateFormatter.string(from: note.modified))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            withAnimation {
                                noteViewModel.toggleFavorite(note)
                            }
                        } label: {
                            Label("Toggle Favorite", systemImage: note.favorite ? "star.slash.fill" : "star.fill")
                        }
                        .tint(.yellow)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation {
                                noteViewModel.delete(note)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
                .id(UUID())
                .animation(.default, value: notes)
            } else {
                EmptyView()
            }
        } header: {
            NoteListSectionHeader(expanded: $expanded, text: sectionHeaderText, icon: sectionHeaderIcon)
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct NoteListSection_Previews: PreviewProvider {
    static var previews: some View {
        let noteViewModel = NoteViewModel(withPersistenceController: .preview)
        return List {
            NoteListSection(
                notes: noteViewModel.favoriteNotes,
                sectionHeaderText: "Favorites",
                sectionHeaderIcon: "star.fill",
                expanded: .constant(true)
            )
            NoteListSection(
                notes: noteViewModel.nonfavoriteNotes,
                sectionHeaderText: "Notes",
                sectionHeaderIcon: "note.text",
                expanded: .constant(false)
            )
        }
    }
}
