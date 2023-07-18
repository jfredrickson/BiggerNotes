//
//  UIFont.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/18/23.
//

import UIKit

extension UIFont {
    // Patches UIFont to support easily specifying a weight.
    func withWeight(_ weight: Weight) -> UIFont {
        var attributes: [UIFontDescriptor.AttributeName: Any] = [:]
        attributes[.family] = familyName
        attributes[.traits] = [kCTFontWeightTrait: weight]
        return UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: pointSize)
    }
}
