//
//  FontPicker.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/21/23.
//

import SwiftUI

struct FontPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var fontName: String
    
    func makeUIViewController(context: Context) -> UIFontPickerViewController {
        let picker = UIFontPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIFontPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onFontSelected: onFontSelected)
    }
    
    // Handler for when the user selects a font
    private func onFontSelected(fontDescriptor: UIFontDescriptor) {
        self.fontName = UIFont(descriptor: fontDescriptor, size: fontDescriptor.pointSize).familyName
        dismiss()
    }
}

extension FontPicker {
    class Coordinator: NSObject, UIFontPickerViewControllerDelegate {
        var onFontSelected: (UIFontDescriptor) -> Void

        init(onFontSelected: @escaping (UIFontDescriptor) -> Void) {
            self.onFontSelected = onFontSelected
            super.init()
        }
        
        func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
            if let selectedFontDescriptor = viewController.selectedFontDescriptor {
                onFontSelected(selectedFontDescriptor)
            }
        }
    }
}
