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
    @StateObject var appSettingsViewModel = AppSettingsViewModel()
    @StateObject var textSettingsViewModel = TextSettingsViewModel()
    @StateObject var router = Router.shared

    var body: some Scene {
        WindowGroup {
            NoteList()
                .environmentObject(noteViewModel)
                .environmentObject(appSettingsViewModel)
                .environmentObject(textSettingsViewModel)
                .environmentObject(router)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            // Delete trashed notes and save all data upon app close
            if phase == .background {
                noteViewModel.deleteAll(onlyTrashed: true)
                noteViewModel.save()
            }
            
            // Start a new note upon app open if that preference is set
            if phase == .active {
                if appSettingsViewModel.startWithNewNote && router.path.isEmpty {
                    router.displayNote(noteViewModel.new())
                }
            }
        }
    }
}
