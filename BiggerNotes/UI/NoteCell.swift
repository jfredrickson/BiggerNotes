//
//  NoteCell.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/24/23.
//

import SwiftUI

struct NoteCell: View {
    @ObservedObject var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.content?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                .lineLimit(1)
            Text(dateFormatter.string(from: note.modified ?? Date()))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell(note: NoteViewModel(withPersistenceController: .preview).new())
    }
}
