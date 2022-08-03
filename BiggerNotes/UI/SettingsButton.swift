//
//  SettingsButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/31/22.
//

import SwiftUI

struct SettingsButton: View {
    @State private var showingTextSettingsSheet = false

    var body: some View {
        Button {
            showingTextSettingsSheet.toggle()
        } label: {
            Label("Settings", systemImage: "textformat.size")
        }
        .sheet(isPresented: $showingTextSettingsSheet) {
            SettingsSheet().presentationDetents([.medium])
        }
    }
}

struct TextSettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}
