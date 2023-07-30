//
//  BiggerNotesApp.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI

@main
struct BiggerNotesApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var noteViewModel = NoteViewModel()
    @StateObject var noteListViewModel = NoteListViewModel()
    @StateObject var textSettingsViewModel = TextSettingsViewModel()
    @StateObject var router = Router.shared

    var body: some Scene {
        WindowGroup {
            NoteList()
                .environmentObject(noteViewModel)
                .environmentObject(noteListViewModel)
                .environmentObject(textSettingsViewModel)
                .environmentObject(router)
        }
        .onChange(of: scenePhase) { phase in
            // Save all data upon app close
            if phase == .background {
                noteViewModel.save()
            }
        }
    }
}
