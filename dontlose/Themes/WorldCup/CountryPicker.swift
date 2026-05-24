import SwiftUI

struct CountryPicker: View {
    @Binding var your: String
    @Binding var opponent: String
    @State private var pickingForYou = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 16) {
                Text("TEAMS")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .tracking(1.5).foregroundStyle(.secondary).frame(width: 140, alignment: .leading)
                HStack(spacing: 12) {
                    slot(title: "YOUR TEAM", code: your, isActive: pickingForYou) { pickingForYou = true }
                    Text("VS").font(.system(size: 16, weight: .heavy)).foregroundStyle(.yellow)
                    slot(title: "OPPONENT", code: opponent, isActive: !pickingForYou) { pickingForYou = false }
                    Button("🎲 Random") {
                        let yc = CountryRegistry.all.randomElement()?.code ?? "COL"
                        your = yc
                        opponent = CountryRegistry.random(excluding: yc).code
                    }.buttonStyle(.bordered)
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 8), spacing: 14) {
                ForEach(CountryRegistry.all) { c in
                    Button(action: {
                        if pickingForYou {
                            your = c.code
                            if opponent == c.code { opponent = CountryRegistry.random(excluding: c.code).code }
                            pickingForYou = false
                        } else {
                            opponent = c.code
                            pickingForYou = true
                        }
                    }) {
                        VStack(spacing: 2) {
                            c.flagBuilder()
                                .frame(width: 44, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(borderColor(for: c.code), lineWidth: 2))
                            Text(c.code).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.leading, 156)
        }
    }

    private func borderColor(for code: String) -> Color {
        if code == your    { return .green }
        if code == opponent { return .yellow }
        return .clear
    }

    private func slot(title: String, code: String, isActive: Bool, onTap: @escaping () -> Void) -> some View {
        let c = CountryRegistry.country(for: code)
        return Button(action: onTap) {
            HStack(spacing: 8) {
                c.flagBuilder().frame(width: 28, height: 18).clipShape(RoundedRectangle(cornerRadius: 2))
                VStack(alignment: .leading) {
                    Text(title).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                    Text(c.name).font(.system(size: 13, weight: .semibold))
                }
            }
            .padding(8)
            .background(isActive ? Color.accentColor.opacity(0.15) : Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }
}
