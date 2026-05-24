import XCTest
@testable import dontlose

final class SmokeTests: XCTestCase {
    func test_appBundleLoads() {
        XCTAssertNotNil(Bundle.main.bundleIdentifier)
    }
}
