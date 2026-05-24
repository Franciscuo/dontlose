import XCTest
@testable import dontlose

final class SessionConfigTests: XCTestCase {
    func test_makeFromMode_usesModeDefaults() {
        let cfg = SessionConfig.default(for: .interview, theme: .minimal)
        XCTAssertEqual(cfg.totalSeconds, 45 * 60)
        XCTAssertEqual(cfg.steps.count, 4)
    }

    func test_secondsPerStep_distributesByPercent() {
        let cfg = SessionConfig.default(for: .commonTask, theme: .minimal)
        let perStep = cfg.secondsPerStep()
        XCTAssertEqual(perStep.count, 3)
        XCTAssertEqual(perStep.reduce(0, +), 25 * 60, "rounded seconds must still sum to total")
        XCTAssertEqual(perStep[0], 150)   // 10% of 1500
        XCTAssertEqual(perStep[1], 1125)  // 75% of 1500
        XCTAssertEqual(perStep[2], 225)   // 15% of 1500
    }

    func test_sessionState_initial_isFirstStepWithFullTime() {
        let cfg = SessionConfig.default(for: .interview, theme: .minimal)
        let s = SessionState.initial(for: cfg)
        XCTAssertEqual(s.currentStepIndex, 0)
        XCTAssertEqual(s.remainingInStep, cfg.secondsPerStep()[0])
        XCTAssertEqual(s.totalRemaining, cfg.totalSeconds)
        XCTAssertEqual(s.lastEvent, .sessionStarted)
        XCTAssertFalse(s.isPaused)
    }
}
