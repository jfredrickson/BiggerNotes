//
//  NoteListSectionHeader.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 11/11/22.
//

import SwiftUI

struct NoteListSectionHeader: View {
    @Binding var expanded: Bool
    var text: String
    var icon: String

    var body: some View {
        HStack {
            Label(text, systemImage: icon)
            Spacer()
            Image(systemName: "chevron.right")
                .bold()
                .foregroundColor(.accentColor)
                .rotationEffect(.degrees(expanded ? 90 : 0))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                expanded.toggle()
            }
        }

    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        return NoteListSectionHeader(expanded: .constant(true), text: "Favorites", icon: "star.fill")
    }
}
