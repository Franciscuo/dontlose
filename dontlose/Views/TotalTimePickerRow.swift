import SwiftUI

struct TotalTimePickerRow: View {
    @Binding var totalSeconds: Int
    private let presets: [Int] = [15, 25, 30, 45, 60].map { $0 * 60 }
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("TOTAL TIME").font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.5).foregroundStyle(.secondary).frame(width: 140, alignment: .leading)
            HStack(spacing: 6) {
                ForEach(presets, id: \.self) { p in
                    Button("\(p/60)m") { totalSeconds = p }
                        .buttonStyle(.bordered)
                        .tint(totalSeconds == p ? .accentColor : .secondary)
                }
            }
        }
    }
}
