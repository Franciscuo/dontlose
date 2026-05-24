import SwiftUI

struct MinimalTheme: Theme {
    let id: ThemeID = .minimal
    var soundPackID: String { "minimal" }

    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView {
        AnyView(EmptyView())
    }

    func makeStageView(viewModel: SessionViewModel) -> AnyView {
        AnyView(MinimalStageView(vm: viewModel))
    }
}

private struct MinimalStageView: View {
    @ObservedObject var vm: SessionViewModel
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color(white: 0.08)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text(format(seconds: vm.state.totalRemaining))
                    .font(.system(size: 96, weight: .heavy, design: .monospaced))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                Text("TOTAL REMAINING")
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .tracking(3)
                    .foregroundStyle(.white.opacity(0.5))
                Spacer()
            }
        }
    }
    private func format(seconds: Int) -> String {
        let m = seconds / 60, s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
