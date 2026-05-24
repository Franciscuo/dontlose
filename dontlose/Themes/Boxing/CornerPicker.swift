import SwiftUI

struct CornerPicker: View {
    @Binding var color: String   // "red" | "blue" | "green" | "yellow"
    var body: some View {
        HStack(spacing: 16) {
            Text("CORNER")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.5).foregroundStyle(.secondary).frame(width: 140, alignment: .leading)
            HStack(spacing: 8) {
                ForEach(["red","blue","green","yellow"], id: \.self) { c in
                    Button(action: { color = c }) {
                        Circle().fill(swatch(c)).frame(width: 28, height: 28)
                            .overlay(Circle().strokeBorder(color == c ? .white : .clear, lineWidth: 2))
                    }.buttonStyle(.plain)
                }
            }
        }
    }
    private func swatch(_ c: String) -> Color {
        switch c { case "blue": return .blue; case "green": return .green; case "yellow": return .yellow; default: return .red }
    }
}
