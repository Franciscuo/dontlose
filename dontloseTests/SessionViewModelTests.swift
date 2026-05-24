import XCTest
@testable import dontlose

@MainActor
final class SessionViewModelTests: XCTestCase {
    var ticks: ManualTickProvider!
    var vm: SessionViewModel!
    var events: [SessionEvent]!

    override func setUp() async throws {
        ticks = ManualTickProvider()
        let cfg = SessionConfig(
            mode: .commonTask,
            theme: .minimal,
            totalSeconds: 60,
            steps: [
                StepDefinition(label: "Plan", percent: 25),
                StepDefinition(label: "Execute", percent: 50),
                StepDefinition(label: "Review", percent: 25),
            ],
            themeOptions: .init()
        )
        events = []
        vm = SessionViewModel(config: cfg, tickProvider: ticks)
        vm.onEvent = { [weak self] in self?.events.append($0) }
    }

    func test_initialState_hasFirstStepFullTime() {
        XCTAssertEqual(vm.state.currentStepIndex, 0)
        XCTAssertEqual(vm.state.remainingInStep, 15)
        XCTAssertEqual(vm.state.totalRemaining, 60)
    }

    func test_start_emitsSessionStartedAndFirstStepStarted() {
        vm.start()
        XCTAssertEqual(events, [.sessionStarted, .stepStarted(index: 0)])
    }

    func test_tickDecrementsRemainingInStepAndTotal() {
        vm.start()
        ticks.fire()
        XCTAssertEqual(vm.state.remainingInStep, 14)
        XCTAssertEqual(vm.state.totalRemaining, 59)
    }

    func test_stepBoundaryAdvancesAndEmitsEvents() {
        vm.start()
        for _ in 0..<15 { ticks.fire() }
        XCTAssertEqual(vm.state.currentStepIndex, 1)
        XCTAssertEqual(vm.state.remainingInStep, 30)
        XCTAssertTrue(events.contains(.stepCompleted(index: 0, wasManualSkip: false)))
        XCTAssertTrue(events.contains(.stepStarted(index: 1)))
    }

    func test_skipStepAdvancesAndEmitsManualSkip() {
        vm.start()
        vm.skipStep()
        XCTAssertEqual(vm.state.currentStepIndex, 1)
        XCTAssertEqual(vm.state.remainingInStep, 30)
        XCTAssertTrue(events.contains(.stepCompleted(index: 0, wasManualSkip: true)))
    }

    func test_pauseStopsTickProcessing_resumeReenables() {
        vm.start()
        vm.pause()
        ticks.fire()
        XCTAssertEqual(vm.state.remainingInStep, 15, "paused — no decrement")
        XCTAssertTrue(events.contains(.paused))
        vm.resume()
        ticks.fire()
        XCTAssertEqual(vm.state.remainingInStep, 14)
        XCTAssertTrue(events.contains(.resumed))
    }

    func test_warningFiresAt30And10SecondsRemainingInStep() {
        let cfg = SessionConfig(mode: .commonTask, theme: .minimal,
                                totalSeconds: 40,
                                steps: [StepDefinition(label: "Only", percent: 100)],
                                themeOptions: .init())
        events = []
        vm = SessionViewModel(config: cfg, tickProvider: ticks)
        vm.onEvent = { [weak self] in self?.events.append($0) }
        vm.start()
        for _ in 0..<10 { ticks.fire() }
        XCTAssertTrue(events.contains(.warningFired(secondsRemaining: 30)))
        for _ in 0..<20 { ticks.fire() }
        XCTAssertTrue(events.contains(.warningFired(secondsRemaining: 10)))
    }

    func test_completesAfterAllSteps() {
        vm.start()
        for _ in 0..<60 { ticks.fire() }
        XCTAssertEqual(vm.state.totalRemaining, 0)
        XCTAssertTrue(events.contains { if case .sessionComplete = $0 { return true } else { return false } })
    }
}
