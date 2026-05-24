import XCTest
@testable import dontlose

final class SettingsStoreTests: XCTestCase {
    var ud: UserDefaults!
    var store: SettingsStore!

    override func setUp() {
        ud = UserDefaults(suiteName: "dontlose.tests.\(UUID().uuidString)")
        store = SettingsStore(defaults: ud)
    }

    func test_defaultLastConfig_isInterviewMinimal45min() {
        let cfg = store.lastConfig
        XCTAssertEqual(cfg.mode, .interview)
        XCTAssertEqual(cfg.theme, .minimal)
        XCTAssertEqual(cfg.totalSeconds, 45 * 60)
    }

    func test_setLastConfig_persistsAndRoundTrips() {
        var cfg = SessionConfig.default(for: .prodBug, theme: .worldCup)
        cfg.themeOptions.yourTeam = "BRA"
        store.lastConfig = cfg

        let rehydrated = SettingsStore(defaults: ud).lastConfig
        XCTAssertEqual(rehydrated.mode, .prodBug)
        XCTAssertEqual(rehydrated.theme, .worldCup)
        XCTAssertEqual(rehydrated.themeOptions.yourTeam, "BRA")
    }

    func test_masterMute_persists() {
        XCTAssertFalse(store.masterMute)
        store.masterMute = true
        XCTAssertTrue(SettingsStore(defaults: ud).masterMute)
    }
}
