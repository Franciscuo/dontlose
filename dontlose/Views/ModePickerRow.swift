import SwiftUI

struct ModePickerRow: View {
    @Binding var selection: Mode
    let onChange: (Mode) -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("MODE")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(1.5).foregroundStyle(.secondary).frame(width: 140, alignment: .leading)
            HStack(spacing: 6) {
                ForEach(Mode.allCases) { mode in
                    Button(mode.displayName) {
                        selection = mode; onChange(mode)
                    }
                    .buttonStyle(.bordered)
                    .tint(selection == mode ? .accentColor : .secondary)
                }
            }
        }
    }
}
