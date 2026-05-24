import Foundation

enum ThemeRegistry {
    static func theme(for id: ThemeID) -> Theme? {
        switch id {
        case .minimal:  return MinimalTheme()
        case .boxing:   return BoxingTheme()
        case .worldCup: return WorldCupTheme()
        }
    }
}
