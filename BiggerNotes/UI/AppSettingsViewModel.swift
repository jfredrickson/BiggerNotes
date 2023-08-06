//
//  AppSettingsViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import SwiftUI

class AppSettingsViewModel: ObservableObject {
    static let DefaultStartWithNewNote = false

    @AppStorage("startWithNewNote") var startWithNewNote = DefaultStartWithNewNote
    @AppStorage("expandFavoritesSection") var expandFavoritesSection = true
    @AppStorage("expandNotesSection") var expandNotesSection = true

    func resetToDefaults() {
        startWithNewNote = AppSettingsViewModel.DefaultStartWithNewNote
    }
}
