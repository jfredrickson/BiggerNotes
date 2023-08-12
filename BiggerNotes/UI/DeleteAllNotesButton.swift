//
//  DeleteAllNotesButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/11/23.
//

import SwiftUI

struct DeleteAllNotesButton: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    @State var isPresentingConfirmation = false
    
    var body: some View {
        Button(role: .destructive) {
            isPresentingConfirmation = true
        } label: {
            Text("Delete all notes")
        }
        .confirmationDialog("Delete ALL notes?", isPresented: $isPresentingConfirmation) {
            Button("Delete all notes", role: .destructive) {
                withAnimation {
                    noteViewModel.deleteAll()
                }
            }
        } message: {
            Text("Are you sure? You cannot undo this!")
        }
    }
}

struct DeleteAllNotesButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAllNotesButton()
    }
}
