//
//  View.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/1/22.
//

import SwiftUI

extension View {
    // Adds an alert view that is automatically shown when an errorMessage is set.
    func errorAlert(errorMessage: Binding<String?>, buttonText: String = "Close") -> some View {
        alert("Sorry, something went wrong!", isPresented: .constant(errorMessage.wrappedValue != nil)) {
            Button(buttonText) {
                errorMessage.wrappedValue = nil
            }
        } message: {
            if let errorMessage = errorMessage.wrappedValue {
                Text(errorMessage)
            }
        }
    }
}
