//
//  SettingsViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/7/22.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    static let MinTextSize = 20.0
    static let MaxTextSize = 80.0
    static let DefaultTextSize = 40.0
    static let DefaultTextWeight = NoteTextWeight.semibold

    @AppStorage("textSize") var textSize = DefaultTextSize
    @AppStorage("textWeight") var textWeight = DefaultTextWeight
}

// Produces text weight options for the settings sheet
enum NoteTextWeight: String, CaseIterable, Identifiable {
    case light = "Light"
    case regular = "Regular"
    case semibold = "Semibold"
    case bold = "Bold"

    // Return the appropriate Font.Weight instance
    var instance: Font.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }

    var id: Self { self }
}
