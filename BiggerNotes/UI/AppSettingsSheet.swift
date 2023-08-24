//
//  AppSettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import SwiftUI
import SwiftUIShakeGesture

struct AppSettingsSheet: View {
    @EnvironmentObject private var appSettingsViewModel: AppSettingsViewModel
    @State private var isPresentingDeleteConfirmation = false
    #if DEBUG
    @State private var devToolsVisible = true
    #else
    @State private var devToolsVisible = false
    #endif
    
    var body: some View {
        SettingsSheet(title: "App Settings") {
            Form {
                Section {
                    Toggle(isOn: $appSettingsViewModel.startWithNewNote, label: {
                        Text("Show blank note on start")
                    })
                    
                    Picker(selection: $appSettingsViewModel.newNoteButtonPosition) {
                        ForEach(NewNoteButtonPosition.allCases) { position in
                            Text(position.text)
                        }
                    } label: {
                        Text("New note button")
                    }
                }
                
                Section {
                    Button {
                    } label: {
                        Text("Reset to defaults")
                    }.onTapGesture {
                        // Executing this in onTapGesture instead of the button action is a workaround to avoid modifying state during view rendering
                        // Reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-fix-modifying-state-during-view-update-this-will-cause-undefined-behavior
                        appSettingsViewModel.resetToDefaults()
                    }
                }
                
                Section {
                    DeleteAllNotesButton()
                }
                
                if (devToolsVisible) {
                    DevToolsSection()
                }
                
                Section {
                } footer: {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Version \(Bundle.main.versionNumber)")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Build \(Bundle.main.buildNumber)")
                            Spacer()
                        }
                    }
                }
            }
        }
        .onShake {
            withAnimation {
                devToolsVisible.toggle()
            }
        }
    }
}

struct AppSettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppSettingsSheet()
                .environmentObject(AppSettingsViewModel())
        }
    }
}
