//
//  AppSettingsViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import SwiftUI

class AppSettingsViewModel: ObservableObject {
    static let DefaultStartWithNewNote = false
    static let DefaultNewNoteButtonPosition = NewNoteButtonPosition.bottom

    @AppStorage("startWithNewNote") var startWithNewNote = DefaultStartWithNewNote
    @AppStorage("expandFavoritesSection") var expandFavoritesSection = true
    @AppStorage("expandNotesSection") var expandNotesSection = true
    @AppStorage("newNoteButtonPosition") var newNoteButtonPosition = DefaultNewNoteButtonPosition

    func resetToDefaults() {
        startWithNewNote = AppSettingsViewModel.DefaultStartWithNewNote
        newNoteButtonPosition = AppSettingsViewModel.DefaultNewNoteButtonPosition
    }
}

enum NewNoteButtonPosition: Int, CaseIterable, Identifiable {
    case top, bottom, both
    
    var id: Self { self }
}
