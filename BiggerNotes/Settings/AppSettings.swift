//
//  AppSettings.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import SwiftUI

class AppSettings: ObservableObject {
    static let DefaultStartWithNewNote = false
    static let DefaultNewNoteButtonPosition = NewNoteButtonPosition.top
    static let DefaultListDensity = ListDensity.comfortable
    
    @AppStorage("startWithNewNote") var startWithNewNote = DefaultStartWithNewNote
    @AppStorage("expandFavoritesSection") var expandFavoritesSection = true
    @AppStorage("expandNotesSection") var expandNotesSection = true
    @AppStorage("newNoteButtonPosition") var newNoteButtonPosition = DefaultNewNoteButtonPosition
    @AppStorage("listDensity") var listDensity = DefaultListDensity

    func resetToDefaults() {
        startWithNewNote = AppSettings.DefaultStartWithNewNote
        newNoteButtonPosition = AppSettings.DefaultNewNoteButtonPosition
        listDensity = AppSettings.DefaultListDensity
    }
}

enum NewNoteButtonPosition: String, CaseIterable, Identifiable, CustomStringConvertible {
    case top
    case bottom
    case both

    var description: String { self.rawValue.capitalized }
    
    var includesTop: Bool {
        return self == .top || self == .both
    }
    
    var includesBottom: Bool {
        return self == .bottom || self == .both
    }
    
    var id: Self { self }
}

enum ListDensity: String, CaseIterable, Identifiable, CustomStringConvertible {
    case compact
    case comfortable
    
    var description: String { self.rawValue.capitalized }
    
    var primaryFont: Font {
        switch self {
        case .compact: return .body
        case .comfortable: return .headline
        }
    }
    
    var secondaryFont: Font {
        switch self {
        case .compact: return .caption
        case .comfortable: return .subheadline
        }
    }
    
    var id: Self { self }
}
