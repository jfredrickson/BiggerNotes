//
//  CreateNewNote.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/5/22.
//

import AppIntents

struct CreateNewNote: AppIntent {
    static var title: LocalizedStringResource = "Create New BiggerNote"
    static var openAppWhenRun: Bool = true

    @MainActor func perform() async throws -> some IntentResult {
        let noteViewModel = NoteViewModel()
        Router.shared.displayNote(noteViewModel.new())
        return .result()
    }
}
