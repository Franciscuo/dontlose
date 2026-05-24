import Foundation

struct StepDefinition: Equatable, Hashable, Codable {
    let label: String
    let percent: Int
}

enum Mode: String, CaseIterable, Identifiable, Codable {
    case interview
    case prodBug
    case commonTask

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .interview:  return "Interview"
        case .prodBug:    return "Prod Bug"
        case .commonTask: return "Common Task"
        }
    }

    var defaultSteps: [StepDefinition] {
        switch self {
        case .interview: return [
            .init(label: "Scope", percent: 15),
            .init(label: "High-level design", percent: 35),
            .init(label: "Deep dive", percent: 35),
            .init(label: "Wrap & scale", percent: 15),
        ]
        case .prodBug: return [
            .init(label: "Triage", percent: 10),
            .init(label: "Mitigate", percent: 40),
            .init(label: "Root cause", percent: 30),
            .init(label: "Postmortem", percent: 20),
        ]
        case .commonTask: return [
            .init(label: "Plan", percent: 10),
            .init(label: "Execute", percent: 75),
            .init(label: "Review", percent: 15),
        ]
        }
    }

    var defaultTotalSeconds: Int {
        switch self {
        case .interview:  return 45 * 60
        case .prodBug:    return 30 * 60
        case .commonTask: return 25 * 60
        }
    }
}
