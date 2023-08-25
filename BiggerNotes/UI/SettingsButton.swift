//
//  SettingsButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/24/23.
//

import SwiftUI

struct SettingsButton<Content>: View where Content : View {
    @State private var showingSheet = false
    private let title: String
    private let systemImage: String
    let popover: () -> Content

    init(title: String = "Settings", systemImage: String = "gearshape", @ViewBuilder _ popover: @escaping () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.popover = popover
    }
    
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            Label(title, systemImage: systemImage)
        }
        .popover(isPresented: $showingSheet) {
            popover().presentationDetents([.medium, .large])
        }
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton {
            EmptyView()
        }
    }
}
