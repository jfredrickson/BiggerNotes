//
//  BiggerNotesApp.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/30/22.
//

import SwiftUI
import CoreData

@main
struct BiggerNotesApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var noteViewModel = NoteViewModel()
    @StateObject var appSettingsViewModel = AppSettingsViewModel()
    @StateObject var textSettingsViewModel = TextSettingsViewModel()
    @StateObject var router = Router.shared
    
    init() {
        let args = ProcessInfo.processInfo.arguments
        
        if args.contains("-resetData") {
            PersistenceController.shared.resetData()
        }
        
        if args.contains("-loadScreenshotData") {
            PersistenceController.shared.loadScreenshotData()
        }
        
        if args.contains("-screenshotVariation1") {
            let textSettings = TextSettingsViewModel()
            textSettings.resetToDefaults()
            textSettings.useCustomColors = true
            textSettings.fontName = "American Typewriter"
            textSettings.textSize = 60
            textSettings.textWeight = .regular
            textSettings.textColor = SettingsColor(.white)
            textSettings.backgroundColor = SettingsColor(.black)
        }
        
        if args.contains("-screenshotVariation2") {
            let textSettings = TextSettingsViewModel()
            textSettings.resetToDefaults()
            textSettings.useCustomColors = true
            textSettings.fontName = "Noteworthy"
            textSettings.textSize = 60
            textSettings.textWeight = .bold
            textSettings.textColor = SettingsColor(Color(red: 1/255, green: 47/255, blue: 123/255))
            textSettings.backgroundColor = SettingsColor(Color(red: 254/255, green: 252/255, blue: 221/255))
        }
        
        if args.contains("-screenshotVariation3") {
            let textSettings = TextSettingsViewModel()
            textSettings.resetToDefaults()
            textSettings.textSize = 100
        }
    }
    
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
            if phase == .background {
                // Delete trashed notes and save all data upon app close
                noteViewModel.deleteAll(onlyTrashed: true)
                noteViewModel.save()
            }
        }
    }
}
