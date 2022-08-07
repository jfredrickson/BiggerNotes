//
//  SettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        NavigationView {
            Form {
                VStack {
                    // Text size
                    HStack {
                        Text("Aa")
                            .font(.system(size: SettingsViewModel.MinTextSize))
                        Slider(
                            value: $settingsViewModel.textSize,
                            in: SettingsViewModel.MinTextSize...SettingsViewModel.MaxTextSize
                        )
                        Text("Aa")
                            .font(.system(size: SettingsViewModel.MaxTextSize))
                    }
                    .frame(height: SettingsViewModel.MaxTextSize + 20)
                    Divider()
                    // Text weight
                    Picker("Text Weight", selection: $settingsViewModel.textWeight) {
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

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsSheet()
                .environmentObject(SettingsViewModel())
        }
    }
}
