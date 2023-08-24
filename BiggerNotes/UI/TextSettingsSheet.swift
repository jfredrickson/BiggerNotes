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
                    
                    // Text size
                    Slider(
                        value: $textSettingsViewModel.textSize,
                        in: TextSettingsViewModel.MinTextSize...TextSettingsViewModel.MaxTextSize
                    )
                    
                    // Text weight
                    Picker("Text Weight", selection: $textSettingsViewModel.textWeight) {
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
                .listRowSeparator(.hidden)
                
                // Color
                Section {
                    Toggle(isOn: $textSettingsViewModel.useCustomColors, label: {
                        Text("Use custom colors")
                    })
                    Group {
                        ColorPicker("Text color", selection: $textSettingsViewModel.textColor)
                        ColorPicker("Background color", selection: $textSettingsViewModel.backgroundColor)
                    }
                    .disabled(!textSettingsViewModel.useCustomColors)
                    .opacity(textSettingsViewModel.useCustomColors ? 1 : 0.5)
                }
                
                // Reset
                Button {
                } label: {
                    Text("Reset to defaults")
                }.onTapGesture {
                    // Executing this in onTapGesture instead of the button action is a workaround to avoid modifying state during view rendering
                    // Reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-fix-modifying-state-during-view-update-this-will-cause-undefined-behavior
                    textSettingsViewModel.resetToDefaults()
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
