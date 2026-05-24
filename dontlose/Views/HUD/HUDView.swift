import SwiftUI

struct HUDView: View {
    @ObservedObject var vm: SessionViewModel

    var body: some View {
        VStack {
            DigitalStepMarker(steps: vm.state.config.steps, currentIndex: vm.state.currentStepIndex)
                .padding(.top, 14)
            Spacer()
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("STEP \(vm.state.currentStepIndex + 1) / \(vm.state.stepCount) · \(vm.state.currentStep?.label.uppercased() ?? "")")
                        .font(.system(size: 11, weight: .regular, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                    Text(format(seconds: vm.state.remainingInStep))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }
                TimerBarView(fraction: stepFraction)
            }
            .padding(.horizontal, 18).padding(.bottom, 14)
            .background(
                LinearGradient(colors: [.black.opacity(0.85), .clear], startPoint: .bottom, endPoint: .top)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
        .allowsHitTesting(false)
    }

    private var stepFraction: Double {
        let total = max(1, vm.state.config.secondsPerStep()[vm.state.currentStepIndex])
        return Double(vm.state.remainingInStep) / Double(total)
    }

    private func format(seconds: Int) -> String {
        let m = seconds / 60, s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
