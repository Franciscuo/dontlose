import Foundation

enum SessionEvent: Equatable, Codable {
    case sessionStarted
    case stepStarted(index: Int)
    case stepCompleted(index: Int, wasManualSkip: Bool)
    case warningFired(secondsRemaining: Int)
    case paused
    case resumed
    case sessionComplete(finishedEarlyBy: Int)
}
