//
//  Color+RawRepresentable.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 2/7/23.
//

import SwiftUI

// Enables Color objects to be saved to AppStorage
extension Color: RawRepresentable {
    public init?(rawValue: String) {
        if let data = Data(base64Encoded: rawValue) {
            do {
                let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .gray
                self = Color(color)
            }
            catch {
                self = .gray
            }
        } else {
            self = .gray
        }
    }

    public var rawValue: String {
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false)
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}
