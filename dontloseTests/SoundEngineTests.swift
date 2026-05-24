import XCTest
@testable import dontlose

final class SoundEngineTests: XCTestCase {
    var engine: SoundEngine!
    var spy: [SoundCue] = []

    override func setUp() {
        spy = []
        engine = SoundEngine(player: { [weak self] cue in self?.spy.append(cue) })
    }

    func test_handleEvent_stepStarted_playsStepStart() {
        engine.handle(.stepStarted(index: 0), pack: SoundPack.boxing)
        XCTAssertEqual(spy, [.stepStart])
    }
    func test_handleEvent_stepCompletedManual_playsStepComplete() {
        engine.handle(.stepCompleted(index: 0, wasManualSkip: true), pack: SoundPack.boxing)
        XCTAssertEqual(spy, [.stepComplete])
    }
    func test_handleEvent_warning30_playsWarning() {
        engine.handle(.warningFired(secondsRemaining: 30), pack: SoundPack.boxing)
        XCTAssertEqual(spy, [.warning])
    }
    func test_muteDisablesAllOutput() {
        engine.isMuted = true
        engine.handle(.stepStarted(index: 0), pack: SoundPack.boxing)
        XCTAssertTrue(spy.isEmpty)
    }
    func test_handleSessionComplete_playsSessionComplete() {
        engine.handle(.sessionComplete(finishedEarlyBy: 0), pack: SoundPack.boxing)
        XCTAssertEqual(spy, [.sessionComplete])
    }
}
