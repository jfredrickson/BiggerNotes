//
//  FloatingButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/27/23.
//

import SwiftUI

struct FloatingButton<LabelContent: View>: View {
    private let action: () -> Void
    private let labelContent: (() -> LabelContent)?
    
    init(
        _ action: @escaping () -> Void,
        label: (() -> LabelContent)? = { EmptyView() })
    {
        self.action = action
        self.labelContent = label
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            Button {
                action()
            } label: {
                if let labelContent {
                    labelContent()
                        .padding()
                        .labelStyle(.iconOnly)
                }
            }
            .glassEffect()
        } else {
            Button {
                action()
            } label: {
                if let labelContent {
                    labelContent()
                }
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton {
        } label: {
            Image(systemName: "ellipsis")
        }
    }
}
