//
//  TextSettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct TextSettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var textSettingsViewModel: TextSettingsViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.system(.headline))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
            .padding([.top, .leading, .trailing])

            Form {
                // Font options
                Section {
                    VStack {
                        // Text size
                        HStack {
                            Text("Aa")
                                .font(.system(size: TextSettingsViewModel.MinTextSize))
                            Slider(
                                value: $textSettingsViewModel.textSize,
                                in: TextSettingsViewModel.MinTextSize...TextSettingsViewModel.MaxTextSize
                            )
                            Text("Aa")
                                .font(.system(size: TextSettingsViewModel.MaxTextSize))
                        }
                        .frame(height: TextSettingsViewModel.MaxTextSize + 20)

                        // Text weight
                        Picker("Text Weight", selection: $textSettingsViewModel.textWeight) {
                            ForEach(NoteTextWeight.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    VStack {
                        // Font
                        Picker("Font", selection: $textSettingsViewModel.fontName) {
                            ForEach(TextSettingsViewModel.availableFonts, id: \.self) { option in
                                Text(option)
                                    .tag(option)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                }

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
        .frame(minWidth: 320, idealWidth: 400, minHeight: 320, idealHeight: 560) // Necessary in order to render popovers properly on iPad
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
