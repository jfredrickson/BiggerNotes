//
//  DevToolsSection.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/11/23.
//

import SwiftUI

struct DevToolsSection: View {
    @EnvironmentObject var noteViewModel: NoteViewModel
    
    var body: some View {
        Section {
            Button {
                noteViewModel.generateTestData()
            } label: {
                Text("Generate test notes")
            }
        } header: {
            Text("Dev Tools")
        }
    }
}

struct AppSettingsDevToolsSection_Previews: PreviewProvider {
    static var previews: some View {
        DevToolsSection()
    }
}
