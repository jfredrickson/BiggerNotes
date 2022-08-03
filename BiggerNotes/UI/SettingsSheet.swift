//
//  SettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct SettingsSheet: View {
    private let MinFontSize = 20.0
    private let MaxFontSize = 60.0

    @Environment(\.dismiss) var dismiss
    @AppStorage("textSize") private var textSize = 40.0
    @AppStorage("textWeight") private var textWeight = NoteTextWeight.semibold

    var body: some View {
        NavigationView {
            Form {
                VStack {
                    // Text size
                    HStack {
                        Text("Aa")
                            .font(.system(size: MinFontSize))
                        Slider(value: $textSize, in: MinFontSize...MaxFontSize)
                        Text("Aa")
                            .font(.system(size: MaxFontSize))
                    }
                    .frame(height: MaxFontSize + 20)
                    Divider()
                    // Text weight
                    Picker("Text Weight", selection: $textWeight) {
                        ForEach(NoteTextWeight.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .scrollDisabled(true)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "xmark.circle")
                    }
                }
            }
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

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsSheet()
        }
    }
}
