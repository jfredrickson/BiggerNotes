//
//  NoteListItem.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/10/23.
//

import SwiftUI

struct NoteListItem: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    @ObservedObject var note: Note
    
    var body: some View {
        NavigationLink(value: note) {
            VStack(alignment: .leading) {
                Text(note.content ?? "")
                    .lineLimit(1)
                Text(dateFormatter.string(from: note.modified ?? Date()))
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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
