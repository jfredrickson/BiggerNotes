//
//  BiggerNotesUnitTests.swift
//  BiggerNotesUnitTests
//
//  Created by Jeff Fredrickson on 2/5/26.
//

import Testing
@testable import BiggerNotes

struct BiggerNotesUnitTests {

    @Test func textSettingsDefaults() {
        #expect(TextSettings.MinTextSize == 20.0)
        #expect(TextSettings.MaxTextSize == 120.0)
        #expect(TextSettings.DefaultTextSize == 50.0)
        #expect(TextSettings.DefaultFont == "Helvetica Neue")
    }

}
