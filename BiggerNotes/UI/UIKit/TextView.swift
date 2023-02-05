//
//  TextView.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 2/2/23.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String

    var textSize: Double
    var textWeight: UIFont.Weight

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.layoutManager.allowsNonContiguousLayout = false // Prevents scroll glitching
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: textSize, weight: textWeight)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
}

extension TextView {
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>

        init(_ text: Binding<String>) {
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }

        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            let toolbar = UIToolbar()
            toolbar.setItems([
                UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClearButton)),
                UIBarButtonItem(systemItem: .flexibleSpace),
                UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: self, action: #selector(handleDoneButton)),
            ], animated: false)
            toolbar.sizeToFit()
            textView.inputAccessoryView = toolbar
            return true
        }

        @objc func handleClearButton() {
            self.text.wrappedValue = ""
        }

        @objc func handleDoneButton() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
