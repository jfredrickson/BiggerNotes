//
//  NoteLink.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/24/23.
//

import SwiftUI

struct NoteLink: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    @ObservedObject var note: Note
    
    var body: some View {
        NavigationLink(value: note) {
            NoteCell(note: note)
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
                            noteViewModel.trash(note)
                        }
                    } label: {
                        Label("Trash", systemImage: "trash.fill")
                    }
                }
        }
    }
}

struct NoteLink_Previews: PreviewProvider {
    static var previews: some View {
        NoteLink(note: NoteViewModel(withPersistenceController: .preview).new())
            .environmentObject(NoteViewModel(withPersistenceController: .preview))
    }
}
