import Foundation

enum ThemeID: String, CaseIterable, Identifiable, Codable {
    case minimal, boxing, worldCup
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .minimal:  return "Minimal"
        case .boxing:   return "Box Fight"
        case .worldCup: return "World Cup 26"
        }
    }
}

struct SessionConfig: Equatable, Codable {
    var mode: Mode
    var theme: ThemeID
    var totalSeconds: Int
    var steps: [StepDefinition]
    var themeOptions: ThemeOptions

    static func `default`(for mode: Mode, theme: ThemeID) -> SessionConfig {
        SessionConfig(
            mode: mode,
            theme: theme,
            totalSeconds: mode.defaultTotalSeconds,
            steps: mode.defaultSteps,
            themeOptions: .init()
        )
    }

    /// Distributes `totalSeconds` across `steps` by percent, with rounding
    /// drift folded into the last step so the sum always equals `totalSeconds`.
    func secondsPerStep() -> [Int] {
        var out = steps.map { Int(round(Double(totalSeconds) * Double($0.percent) / 100.0)) }
        let drift = totalSeconds - out.reduce(0, +)
        if !out.isEmpty { out[out.count - 1] += drift }
        return out
    }
}

struct ThemeOptions: Equatable, Codable {
    var yourTeam: String = "COL"
    var opponentTeam: String = "FRA"
    var cornerColor: String = "red"
}
