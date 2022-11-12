//
//  NoteListViewModel.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 11/11/22.
//

import SwiftUI

class NoteListViewModel: ObservableObject {
    @AppStorage("expandFavoritesSection") var expandFavoritesSection = true
    @AppStorage("expandNotesSection") var expandNotesSection = true
}
