//
//  AppSettingsButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import SwiftUI

struct AppSettingsButton: View {
    @State private var showingAppSettingsSheet = false

    var body: some View {
        Button {
            showingAppSettingsSheet.toggle()
        } label: {
            Label("App Settings", systemImage: "gearshape")
        }
        .popover(isPresented: $showingAppSettingsSheet) {
            AppSettingsSheet().presentationDetents([.medium, .large])
        }
    }
}

struct AppSettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsButton()
    }
}

