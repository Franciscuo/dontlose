import SwiftUI

struct ThemePickerRow: View {
    @Binding var selection: ThemeID
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("ANIMATION").font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.5).foregroundStyle(.secondary).frame(width: 140, alignment: .leading)
            HStack(spacing: 6) {
                ForEach(ThemeID.allCases) { id in
                    Button(displayLabel(id)) { selection = id }
                        .buttonStyle(.bordered)
                        .tint(selection == id ? .accentColor : .secondary)
                }
            }
        }
    }
    private func displayLabel(_ id: ThemeID) -> String {
        switch id {
        case .minimal:  return "▫️ Minimal"
        case .boxing:   return "🥊 Box Fight"
        case .worldCup: return "⚽ World Cup 26"
        }
    }
}
