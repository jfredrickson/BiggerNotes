//
//  Screenshots.swift
//  BiggerNotesScreenshots
//
//  Created by Jeff Fredrickson on 9/30/25.
//

import XCTest

// Takes advantage of UI tests to produce screenshots for the App Store.
final class Screenshots: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }
    
    func screenshot(_ name: String) {
        sleep(1)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    
    @MainActor
    func testNoteList() throws {
        XCUIDevice.shared.appearance = .dark
        
        app.launchArguments += ["-resetData", "-loadScreenshotData", "-screenshotVariation3"]
        app.launch()
        
        screenshot("Note List")
    }
    
    @MainActor
    func testNoteVariation1() throws {
        XCUIDevice.shared.appearance = .dark
        
        app.launchArguments += ["-resetData", "-loadScreenshotData", "-screenshotVariation1"]
        app.launch()
        
        app.staticTexts["00000000-0000-0000-0000-000000000000"].firstMatch.tap()
        screenshot("Note Variation 1")
    }
    
    @MainActor
    func testNoteVariation2() throws {
        XCUIDevice.shared.appearance = .light
        
        app.launchArguments += ["-resetData", "-loadScreenshotData", "-screenshotVariation2"]
        app.launch()
        
        app.staticTexts["00000000-0000-0000-0000-000000000001"].firstMatch.tap()
        screenshot("Note Variation 2")
    }
    
    @MainActor
    func testNoteVariation3() throws {
        XCUIDevice.shared.appearance = .light
        
        app.launchArguments += ["-resetData", "-loadScreenshotData", "-screenshotVariation3"]
        app.launch()
        
        app.staticTexts["00000000-0000-0000-0000-000000000002"].firstMatch.tap()
        screenshot("Note Variation 3")
    }
}
