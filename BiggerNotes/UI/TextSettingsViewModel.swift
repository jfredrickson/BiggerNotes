//
//  TextSettingsViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/7/22.
//

import SwiftUI

class TextSettingsViewModel: ObservableObject {
    static let MinTextSize = 20.0
    static let MaxTextSize = 120.0
    static let DefaultTextSize = 50.0
    static let DefaultTextWeight = NoteTextWeight.semibold
    static let DefaultFont = "System"
    static let DefaultUseCustomColors = false
    static let DefaultTextColor = Color.black
    static let DefaultBackgroundColor = Color.white

    @AppStorage("textSize") var textSize = DefaultTextSize
    @AppStorage("textWeight") var textWeight = DefaultTextWeight
    @AppStorage("font") var fontName = DefaultFont
    @AppStorage("useCustomColors") var useCustomColors = DefaultUseCustomColors
    @AppStorage("textColor") var textColor = DefaultTextColor
    @AppStorage("backgroundColor") var backgroundColor = DefaultBackgroundColor

    var uiFont: UIFont {
        get {
            if (fontName == "System") {
                return UIFont.systemFont(ofSize: textSize, weight: textWeight.instance)
            } else {
                return UIFont(descriptor: UIFontDescriptor(fontAttributes: [.name: fontName]), size: textSize)
                    .withWeight(textWeight.instance)
            }
        }
    }
    
    var uiTextColor: UIColor {
        get {
            if (useCustomColors) {
                return UIColor(textColor)
            } else {
                return .label
            }
        }
    }
    
    var uiBackgroundColor: UIColor {
        get {
            if (useCustomColors) {
                return UIColor(backgroundColor)
            } else {
                return .systemBackground
            }
        }
    }
    
    func font(size: CGFloat, weight: UIFont.Weight) -> Font {
        if (fontName == "System") {
            let uiFont = UIFont.systemFont(ofSize: size, weight: weight)
            return Font(uiFont)
        } else {
            let uiFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: [.name: fontName]), size: size)
                .withWeight(weight)
            return Font(uiFont)
        }
    }
    
    func resetToDefaults() {
        textSize = TextSettingsViewModel.DefaultTextSize
        textWeight = TextSettingsViewModel.DefaultTextWeight
        fontName = TextSettingsViewModel.DefaultFont
        useCustomColors = TextSettingsViewModel.DefaultUseCustomColors
    }
    
    static let availableFonts = [
        "System",
        "American Typewriter",
        "Avenir Next",
        "Avenir Next Condensed",
        "Chalkboard SE",
        "Charter",
        "Copperplate",
        "Courier New",
        "Gill Sans",
        "Menlo",
        "Noteworthy",
        "Optima",
    ]
}

// Produces text weight options for the settings sheet
enum NoteTextWeight: String, CaseIterable, Identifiable {
    case light = "Light"
    case regular = "Regular"
    case semibold = "Semibold"
    case bold = "Bold"

    // Return the appropriate Font.Weight instance
    var instance: UIFont.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }

    var id: Self { self }
}
