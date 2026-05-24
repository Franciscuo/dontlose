import XCTest
@testable import dontlose

final class ModeTests: XCTestCase {
    func test_interview_hasFourStepsSummingTo100Percent() {
        let m = Mode.interview
        XCTAssertEqual(m.defaultSteps.count, 4)
        XCTAssertEqual(m.defaultSteps.map(\.percent).reduce(0, +), 100)
        XCTAssertEqual(m.defaultSteps.map(\.label), ["Scope", "High-level design", "Deep dive", "Wrap & scale"])
        XCTAssertEqual(m.defaultTotalSeconds, 45 * 60)
    }

    func test_prodBug_hasFourStepsBiasedToMitigation() {
        let m = Mode.prodBug
        XCTAssertEqual(m.defaultSteps.count, 4)
        XCTAssertEqual(m.defaultSteps.map(\.percent), [10, 40, 30, 20])
        XCTAssertEqual(m.defaultTotalSeconds, 30 * 60)
    }

    func test_commonTask_hasThreeStepsExecuteHeavy() {
        let m = Mode.commonTask
        XCTAssertEqual(m.defaultSteps.count, 3)
        XCTAssertEqual(m.defaultSteps.map(\.percent), [10, 75, 15])
        XCTAssertEqual(m.defaultTotalSeconds, 25 * 60)
    }

    func test_percentagesAlwaysSumTo100() {
        for mode in Mode.allCases {
            XCTAssertEqual(mode.defaultSteps.map(\.percent).reduce(0, +), 100, "\(mode) splits must sum to 100")
        }
    }
}
