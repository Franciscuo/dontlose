import Foundation
import Combine

@MainActor
final class SessionViewModel: ObservableObject {
    @Published private(set) var state: SessionState
    var onEvent: ((SessionEvent) -> Void)?

    private let tickProvider: TickProvider
    private let secondsPerStep: [Int]
    private var firedWarnings: Set<Int> = []

    init(config: SessionConfig, tickProvider: TickProvider) {
        self.state = SessionState.initial(for: config)
        self.tickProvider = tickProvider
        self.secondsPerStep = config.secondsPerStep()
        self.tickProvider.onTick = { [weak self] in self?.tick() }
    }

    func start() {
        emit(.sessionStarted)
        emit(.stepStarted(index: state.currentStepIndex))
        tickProvider.start()
    }

    func pause() {
        guard !state.isPaused else { return }
        state.isPaused = true
        tickProvider.stop()
        emit(.paused)
    }

    func resume() {
        guard state.isPaused else { return }
        state.isPaused = false
        tickProvider.start()
        emit(.resumed)
    }

    func skipStep() {
        advanceStep(manual: true)
    }

    func restart() {
        tickProvider.stop()
        state = SessionState.initial(for: state.config)
        firedWarnings.removeAll()
        start()
    }

    private func tick() {
        guard !state.isPaused, state.totalRemaining > 0 else { return }
        state.remainingInStep -= 1
        state.totalRemaining -= 1

        // De-dup key: threshold * 1000 + stepIndex (so 30/10 thresholds never collide across steps).
        if state.remainingInStep == 30, !firedWarnings.contains(30 * 1000 + state.currentStepIndex) {
            firedWarnings.insert(30 * 1000 + state.currentStepIndex)
            emit(.warningFired(secondsRemaining: 30))
        }
        if state.remainingInStep == 10, !firedWarnings.contains(10 * 1000 + state.currentStepIndex) {
            firedWarnings.insert(10 * 1000 + state.currentStepIndex)
            emit(.warningFired(secondsRemaining: 10))
        }

        if state.remainingInStep <= 0 {
            advanceStep(manual: false)
        }
    }

    private func advanceStep(manual: Bool) {
        let finishedIndex = state.currentStepIndex
        emit(.stepCompleted(index: finishedIndex, wasManualSkip: manual))

        let next = finishedIndex + 1
        if next >= state.config.steps.count {
            if manual {
                state.totalRemaining = max(state.totalRemaining, 0)
            }
            tickProvider.stop()
            let savedEarlyBy = max(state.totalRemaining, 0)
            state.totalRemaining = 0
            state.remainingInStep = 0
            emit(.sessionComplete(finishedEarlyBy: savedEarlyBy))
            return
        }

        state.currentStepIndex = next
        let stepLen = secondsPerStep[next]
        if manual {
            state.totalRemaining -= state.remainingInStep
        }
        state.remainingInStep = stepLen
        emit(.stepStarted(index: next))
    }

    private func emit(_ event: SessionEvent) {
        state.lastEvent = event
        onEvent?(event)
    }
}
