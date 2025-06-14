//
//  TextView.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 2/2/23.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String?

    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textColor: UIColor = .label
    var backgroundColor: UIColor = .systemBackground

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.delegate = context.coordinator
        textView.layoutManager.allowsNonContiguousLayout = false // Prevents scroll glitching
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.text = text

        if text != nil && text!.isEmpty {
            textView.becomeFirstResponder()
        }

        let toolbar = UIToolbar()
        toolbar.setItems([
            UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(textView.clear)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(
                image: UIImage(systemName: "keyboard.chevron.compact.down"),
                style: .plain,
                target: self,
                action: #selector(textView.doneEditing)
            ),
        ], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        // Avoid duplicate updates due to SwiftUI triggering updateUIView and UIKit triggering textViewDidChange
        if textView.font != font {
            textView.font = font
        }
        if textView.textColor != textColor {
            textView.textColor = textColor
        }
        if textView.backgroundColor != backgroundColor {
            textView.backgroundColor = backgroundColor
        }
        if textView.text != text {
            // Preserve selected range so cursor is reinserted at the correct position after updating
            let selectedRange = textView.selectedRange
            textView.text = text
            textView.selectedRange = selectedRange
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(_ parent: TextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

extension TextView {
    func font(_ font: UIFont) -> TextView {
        var view = self
        view.font = font
        return view
    }

    func textColor(_ color: UIColor) -> TextView {
        var view = self
        view.textColor = color
        return view
    }

    func backgroundColor(_ color: UIColor) -> TextView {
        var view = self
        view.backgroundColor = color
        return view
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
