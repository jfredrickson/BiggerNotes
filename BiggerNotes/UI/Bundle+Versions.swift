//
//  Bundle+Versions.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 7/29/23.
//

import Foundation

extension Bundle {
    var versionNumber: String {
        if let version = infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "unspecified"
        }
    }
    
    var buildNumber: String {
        if let build = infoDictionary?["CFBundleVersion"] as? String {
            return build
        } else {
            return "unspecified"
        }
    }
}
