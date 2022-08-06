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

    func displayNote(_ note: Note) {
        path.removeAll()
        path.append(note)
    }

    func displayNoteList() {
        path.removeAll()
    }
}
