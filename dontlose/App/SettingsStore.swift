import Foundation

final class SettingsStore {
    private let defaults: UserDefaults
    private let lastConfigKey = "dontlose.lastConfig.v1"
    private let masterMuteKey = "dontlose.masterMute.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var lastConfig: SessionConfig {
        get {
            if let data = defaults.data(forKey: lastConfigKey),
               let cfg = try? JSONDecoder().decode(SessionConfig.self, from: data) {
                return cfg
            }
            return SessionConfig.default(for: .interview, theme: .minimal)
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: lastConfigKey)
            }
        }
    }

    var masterMute: Bool {
        get { defaults.bool(forKey: masterMuteKey) }
        set { defaults.set(newValue, forKey: masterMuteKey) }
    }
}
