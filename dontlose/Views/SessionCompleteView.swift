import SwiftUI

struct SessionCompleteView: View {
    @EnvironmentObject var router: AppRouter
    let config: SessionConfig

    var body: some View {
        VStack(spacing: 16) {
            Text("Round complete.")
                .font(.system(size: 40, weight: .heavy))
            Text("\(config.steps.count) / \(config.steps.count) steps · \(config.mode.displayName) · \(config.totalSeconds / 60) min")
                .foregroundStyle(.secondary)
            HStack(spacing: 10) {
                Button("Run again") { router.startSession(with: config) }
                    .keyboardShortcut(.return)
                    .buttonStyle(.borderedProminent)
                Button("Back to setup") { router.backToSetup() }
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.95))
        .foregroundStyle(.white)
    }
}
