//
//  TextSettings.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/7/22.
//

import SwiftUI

class TextSettings: ObservableObject {
    static let MinTextSize = 20.0
    static let MaxTextSize = 120.0
    static let DefaultTextSize = 50.0
    static let DefaultTextWeight = NoteTextWeight.semibold
    static let DefaultFont = "Helvetica Neue"
    static let DefaultUseCustomColors = false
    static let DefaultTextColor = SettingsColor(.black)
    static let DefaultBackgroundColor = SettingsColor(.white)

    @AppStorage("textSize") var textSize = DefaultTextSize
    @AppStorage("textWeight") var textWeight = DefaultTextWeight
    @AppStorage("font") var _fontName = DefaultFont
    @AppStorage("useCustomColors") var useCustomColors = DefaultUseCustomColors
    @AppStorage("textColor") var textColor = DefaultTextColor
    @AppStorage("backgroundColor") var backgroundColor = DefaultBackgroundColor

    // Wrap the _fontName property with a custom setter to also adjust the selected weight if
    // necessary
    var fontName: String {
        get { _fontName }
        set {
            _fontName = newValue
            if !availableWeights.contains(textWeight) {
                textWeight = .regular
            }
        }
    }
    
    // Provides an UIFont for the TextView font
    var uiFont: UIFont {
        get {
            return UIFont(descriptor: UIFontDescriptor(fontAttributes: [.name: fontName]), size: textSize)
                .withWeight(textWeight.instance)
        }
    }
    
    // Provides an UIColor for the TextView text color
    var uiTextColor: UIColor {
        get {
            if (useCustomColors) {
                return UIColor(textColor.color)
            } else {
                return .label
            }
        }
    }
    
    // Provides an UIColor for the TextView background color
    var uiBackgroundColor: UIColor {
        get {
            if (useCustomColors) {
                return UIColor(backgroundColor.color)
            } else {
                return .systemBackground
            }
        }
    }
    
    // Reset all settings to default values
    func resetToDefaults() {
        textSize = TextSettings.DefaultTextSize
        textWeight = TextSettings.DefaultTextWeight
        fontName = TextSettings.DefaultFont
        useCustomColors = TextSettings.DefaultUseCustomColors
    }
    
    // Return a list of available weights based on the currently selected font
    var availableWeights: [NoteTextWeight] {
        get {
            // To determine which fonts support which weights (light, regular, semibold, bold), use
            // the hash of each UIFontDescriptor to see if there is any differentiation between the
            // various weights.
            //
            // - If light and regular hashes are different, then the font supports both
            // - If light and regular hashes are same, then the font only supports regular
            // - If semibold and bold hashes are different, then the font supports both
            // - If semibold and bold hashes are same, then the font only supports bold

            let lightHash = uiFont.withWeight(.light).fontDescriptor.hashValue
            let regularHash = uiFont.withWeight(.regular).fontDescriptor.hashValue
            let semiboldHash = uiFont.withWeight(.semibold).fontDescriptor.hashValue
            let boldHash = uiFont.withWeight(.bold).fontDescriptor.hashValue

            var weights: [NoteTextWeight] = []
            
            if lightHash != regularHash {
                weights.append(.light)
            }
            
            weights.append(.regular)
            
            if semiboldHash != boldHash {
                weights.append(.semibold)
            }
            
            if regularHash != boldHash {
                weights.append(.bold)
            }
            
            return weights
        }
    }
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
