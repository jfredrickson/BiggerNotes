//
//  SettingsSheet.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/24/23.
//

import SwiftUI

struct SettingsSheet<Content>: View where Content : View {
    @Environment(\.dismiss) private var dismiss
    private let title: String
    let content: () -> Content
    
    init(title: String = "Settings", @ViewBuilder _ content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                content()
            }
            .navigationTitle(Text(title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                    }
                }
            }
        }
        .frame(minWidth: 320, idealWidth: 400, minHeight: 320, idealHeight: 560) // Necessary in order to render popovers properly on iPad
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet {
            EmptyView()
        }
    }
}
