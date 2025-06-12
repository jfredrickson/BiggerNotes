//
//  SettingsColor.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 6/11/25.
//

import SwiftUI

struct SettingsColor: RawRepresentable {
    var color: Color
    
    init(_ color: Color) {
        self.color = color
    }
    
    typealias RawValue = String

    init(rawValue: String) {
        if let data = Data(base64Encoded: rawValue) {
            do {
                let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .gray
                self.color = Color(uiColor)
            } catch {
                self.color = .gray
            }
        } else {
            self.color = .gray
        }
    }

    var rawValue: String {
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self.color), requiringSecureCoding: false)
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}
