import SwiftUI

struct SetupView: View {
    @EnvironmentObject var router: AppRouter
    @State private var draft: SessionConfig = .default(for: .interview, theme: .minimal)

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            ModePickerRow(selection: $draft.mode, onChange: applyModeDefaults)
            TotalTimePickerRow(totalSeconds: $draft.totalSeconds)
            ThemePickerRow(selection: $draft.theme)

            if let theme = ThemeRegistry.theme(for: draft.theme) {
                theme.makeSetupAccessory(options: $draft.themeOptions)
            }

            Spacer()
            HStack {
                Button("▶  Start session") { router.startSession(with: draft) }
                    .keyboardShortcut(.return)
                    .buttonStyle(.borderedProminent)
                Button("Use last preset") { draft = router.settings.lastConfig }
                    .buttonStyle(.bordered)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear { draft = router.settings.lastConfig }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("dontlose").font(.system(size: 36, weight: .heavy))
            Text("Don't lose to the clock.").foregroundStyle(.secondary)
        }
    }

    private func applyModeDefaults(_ mode: Mode) {
        draft.steps = mode.defaultSteps
        draft.totalSeconds = mode.defaultTotalSeconds
    }
}
