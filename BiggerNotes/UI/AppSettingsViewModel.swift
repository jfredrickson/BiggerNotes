//
//  AppSettingsViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import SwiftUI

class AppSettingsViewModel: ObservableObject {
    static let DefaultStartWithNewNote = false
    static let DefaultNewNoteButtonPosition = NewNoteButtonPosition.top

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
    case top
    case bottom
    case both

    var text: String {
        switch self {
        case .top: return "Top"
        case .bottom: return "Bottom"
        case .both: return "Both"
        }
    }
    
    var includesTop: Bool {
        return self == .top || self == .both
    }
    
    var includesBottom: Bool {
        return self == .bottom || self == .both
    }
    
    var id: Self { self }
}
