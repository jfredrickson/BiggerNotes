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
                    
                    Picker(selection: $appSettingsViewModel.listDensity) {
                        ForEach(ListDensity.allCases) { density in
                            Text(String(describing: density))
                        }
                    } label: {
                        Text("Note list density")
                    }
                }
                
                Section {
                    Button {
                        appSettingsViewModel.resetToDefaults()
                    } label: {
                        Text("Reset to defaults")
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
