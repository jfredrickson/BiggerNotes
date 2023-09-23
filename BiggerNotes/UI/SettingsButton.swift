//
//  SettingsButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/24/23.
//

import SwiftUI

struct SettingsButton<Content>: View where Content : View {
    @Binding private var showingSheet: Bool
    private let title: String
    private let systemImage: String
    let popover: () -> Content

    init(showingSheet: Binding<Bool>, title: String = "Settings", systemImage: String = "gearshape", @ViewBuilder _ popover: @escaping () -> Content) {
        self._showingSheet = showingSheet
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
        SettingsButton(showingSheet: .constant(true)) {
            EmptyView()
        }
    }
}
