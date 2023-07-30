//
//  TextView.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 2/2/23.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @EnvironmentObject var textSettingsViewModel: TextSettingsViewModel

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.layoutManager.allowsNonContiguousLayout = false // Prevents scroll glitching

        if text.isEmpty {
            textView.becomeFirstResponder()
        }

        let toolbar = UIToolbar()
        toolbar.setItems([
            UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(textView.clear)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .done, target: self, action: #selector(textView.doneEditing)),
        ], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text
        
        if (textSettingsViewModel.font == "System") {
            textView.font = UIFont.systemFont(ofSize: textSettingsViewModel.textSize, weight: textSettingsViewModel.textWeight.instance)
        } else {
            textView.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [.name: textSettingsViewModel.font]), size: textSettingsViewModel.textSize)
                .withWeight(textSettingsViewModel.textWeight.instance)
        }
        
        if (textSettingsViewModel.useCustomColors) {
            textView.textColor = UIColor(textSettingsViewModel.textColor)
            textView.backgroundColor = UIColor(textSettingsViewModel.backgroundColor)
        } else {
            textView.textColor = .label
            textView.backgroundColor = .systemBackground
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
}

extension UITextView {
    @objc func clear() {
        // This approach clears the text while still allowing for undo functionality
        self.selectedRange = NSMakeRange(0, self.textStorage.length)
        self.insertText("")
    }

    @objc func doneEditing() {
        self.resignFirstResponder()
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
    }
}
