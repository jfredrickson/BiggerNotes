//
//  FloatingButton.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/27/23.
//

import SwiftUI

struct FloatingButton<LabelContent: View>: View {
    private var offset: CGSize
    private let action: () -> Void
    private let labelContent: (() -> LabelContent)?
    
    init(
        offset: CGSize = CGSize(),
        _ action: @escaping () -> Void,
        label: (() -> LabelContent)? = { EmptyView() })
    {
        self.offset = offset
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
                        .foregroundColor(.primary)
                        .bold()
                        .labelStyle(.iconOnly)
                        .padding()
                }
            }
            .glassEffect()
            .offset(offset)
            .padding()
        } else {
            Button {
                action()
            } label: {
                if let labelContent {
                    labelContent()
                }
            }
            .padding()
            .font(.system(.body).weight(.bold))
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
            .offset(offset)
            .padding()
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
