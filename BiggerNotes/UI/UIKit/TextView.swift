//
//  TextView.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 2/2/23.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String

    private var textSize: Double
    private var textWeight: UIFont.Weight

    init(text: Binding<String>, textSize: Double, textWeight: UIFont.Weight) {
        _text = text
        self.textSize = textSize
        self.textWeight = textWeight
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text
        DispatchQueue.main.async {
            textView.font = UIFont.systemFont(ofSize: textSize, weight: textWeight)
        }
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
            toolbar.barStyle = .default
            toolbar.backgroundColor = .systemBackground
            toolbar.sizeToFit()
            toolbar.isUserInteractionEnabled = true
            toolbar.setItems([
//                UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClearButton)),
                UIBarButtonItem(systemItem: .flexibleSpace),
                UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: self, action: #selector(handleDoneButton)),
            ], animated: false)
            textView.inputAccessoryView = toolbar
            return true
        }

//        @objc func handleClearButton() {
//            self.text.wrappedValue = ""
//        }

        @objc func handleDoneButton() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
