//
//  Router.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/5/22.
//

import SwiftUI

class Router: ObservableObject {
    static let shared = Router()

    @Published var path: [Note] = []
    @Published var showingAppSettings = false
    @Published var showingTextSettings = false

    func displayNote(_ note: Note) {
        showingAppSettings = false
        showingTextSettings = false
        path.removeAll()
        path.append(note)
    }

    func displayNoteList() {
        path.removeAll()
    }
}
