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
                "New note in \(.applicationName)",
                "New \(.applicationName)",
                "Create new note in \(.applicationName)",
                "Create new \(.applicationName)",
                "Create note in \(.applicationName)",
                "Create \(.applicationName)",
            ],
            systemImageName: "square.and.pencil"
        )
    }
}
