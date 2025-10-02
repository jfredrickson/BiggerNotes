//
//  TextSettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct TextSettingsSheet: View {
    @EnvironmentObject private var textSettingsViewModel: TextSettingsViewModel
    
    var body: some View {
        SettingsSheet(title: "Text Settings") {
            Form {
                // Font options
                Section {
                    // Text preview
                    HStack {
                        Spacer()
                        Text("Hi")
                            .font(Font(textSettingsViewModel.uiFont))
                            .frame(height: TextSettingsViewModel.MaxTextSize)
                        Spacer()
                    }
                    .foregroundStyle(Color(textSettingsViewModel.uiTextColor))
                    .background(Color(textSettingsViewModel.uiBackgroundColor))
                    .cornerRadius(8)
                    .listRowSeparator(.hidden)
                    
                    // Text size
                    Slider(
                        value: $textSettingsViewModel.textSize,
                        in: TextSettingsViewModel.MinTextSize...TextSettingsViewModel.MaxTextSize
                    )
                    .listRowSeparator(.hidden)
                    .accessibilityLabel(Text("Text size"))
                    
                    // Text weight
                    Picker("Text weight", selection: $textSettingsViewModel.textWeight) {
                        ForEach(textSettingsViewModel.availableWeights) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Font
                    NavigationLink {
                        FontPicker(fontName: $textSettingsViewModel.fontName)
                            .navigationTitle("Fonts")
                    } label: {
                        Text(textSettingsViewModel.fontName)
                    }
                }
                
                // Color
                Section {
                    Toggle(isOn: $textSettingsViewModel.useCustomColors, label: {
                        Text("Use custom colors")
                    })
                    Group {
                        ColorPicker("Text color", selection: $textSettingsViewModel.textColor.color)
                        ColorPicker("Background color", selection: $textSettingsViewModel.backgroundColor.color)
                    }
                    .disabled(!textSettingsViewModel.useCustomColors)
                    .opacity(textSettingsViewModel.useCustomColors ? 1 : 0.5)
                }
                
                // Reset
                Button {
                    textSettingsViewModel.resetToDefaults()
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
                .environmentObject(TextSettingsViewModel())
        }
    }
}
