import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    enum Route: Equatable {
        case setup
        case session(SessionConfig)
        case complete(SessionConfig)
    }
    @Published var route: Route = .setup

    let settings: SettingsStore
    init(settings: SettingsStore = SettingsStore()) { self.settings = settings }

    func startSession(with cfg: SessionConfig) {
        settings.lastConfig = cfg
        route = .session(cfg)
    }
    func sessionDidComplete(cfg: SessionConfig) { route = .complete(cfg) }
    func backToSetup() { route = .setup }
}
