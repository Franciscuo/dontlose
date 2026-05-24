import XCTest
import SwiftUI
@testable import dontlose

final class ThemeRegistryTests: XCTestCase {
    func test_registry_returnsThemeForEachID() {
        for id in ThemeID.allCases {
            XCTAssertNotNil(ThemeRegistry.theme(for: id), "missing theme for \(id)")
        }
    }
    func test_themeIDMatchesRegisteredTheme() {
        for id in ThemeID.allCases {
            XCTAssertEqual(ThemeRegistry.theme(for: id)?.id, id)
        }
    }
}
