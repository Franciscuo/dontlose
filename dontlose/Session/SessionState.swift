import Foundation

struct SessionState: Equatable {
    let config: SessionConfig
    var currentStepIndex: Int
    var remainingInStep: Int
    var totalRemaining: Int
    var isPaused: Bool
    var lastEvent: SessionEvent

    static func initial(for cfg: SessionConfig) -> SessionState {
        SessionState(
            config: cfg,
            currentStepIndex: 0,
            remainingInStep: cfg.secondsPerStep().first ?? cfg.totalSeconds,
            totalRemaining: cfg.totalSeconds,
            isPaused: false,
            lastEvent: .sessionStarted
        )
    }

    var currentStep: StepDefinition? {
        config.steps.indices.contains(currentStepIndex) ? config.steps[currentStepIndex] : nil
    }

    var stepCount: Int { config.steps.count }
}
