//
//  TextSettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct TextSettingsSheet: View {
    @EnvironmentObject private var textSettings: TextSettings
    
    var body: some View {
        SettingsSheet(title: "Text Settings") {
            Form {
                // Font options
                Section {
                    // Text preview
                    HStack {
                        Spacer()
                        Text("Hi")
                            .font(Font(textSettings.uiFont))
                            .frame(height: TextSettings.MaxTextSize)
                        Spacer()
                    }
                    .foregroundStyle(Color(textSettings.uiTextColor))
                    .background(Color(textSettings.uiBackgroundColor))
                    .cornerRadius(8)
                    .listRowSeparator(.hidden)
                    
                    // Text size
                    Slider(
                        value: $textSettings.textSize,
                        in: TextSettings.MinTextSize...TextSettings.MaxTextSize
                    )
                    .listRowSeparator(.hidden)
                    .accessibilityLabel(Text("Text size"))
                    
                    // Text weight
                    Picker("Text weight", selection: $textSettings.textWeight) {
                        ForEach(textSettings.availableWeights) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Font
                    NavigationLink {
                        FontPicker(fontName: $textSettings.fontName)
                            .navigationTitle("Fonts")
                    } label: {
                        Text(textSettings.fontName)
                    }
                }
                
                // Color
                Section {
                    Toggle(isOn: $textSettings.useCustomColors, label: {
                        Text("Use custom colors")
                    })
                    Group {
                        ColorPicker("Text color", selection: $textSettings.textColor.color)
                        ColorPicker("Background color", selection: $textSettings.backgroundColor.color)
                    }
                    .disabled(!textSettings.useCustomColors)
                    .opacity(textSettings.useCustomColors ? 1 : 0.5)
                }
                
                // Reset
                Button {
                    textSettings.resetToDefaults()
                } label: {
                    Text("Reset to defaults")
                }
            }
        }
    }
}

struct TextSettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextSettingsSheet()
                .environmentObject(TextSettings())
        }
    }
}
