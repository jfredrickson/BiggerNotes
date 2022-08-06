//
//  AppShortcuts.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/5/22.
//

import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateNewNote(),
            phrases: [
                "Create new BiggerNote",
                "New BiggerNote",
                "Create BiggerNote",
                "Create new note in \(.applicationName)",
                "New note in \(.applicationName)",
                "Create note in \(.applicationName)"
            ],
            systemImageName: "square.and.pencil"
        )
    }
}
