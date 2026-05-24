import SwiftUI

struct DigitalStepMarker: View {
    let steps: [StepDefinition]
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Array(steps.enumerated()), id: \.offset) { (i, step) in
                segment(index: i, step: step, status: status(for: i))
            }
        }
        .padding(8)
        .background(Color(red: 0.04, green: 0.04, blue: 0.06))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color(red: 0.12, green: 0.12, blue: 0.17), lineWidth: 2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.6), radius: 14, y: 4)
    }

    private enum Status { case done, active, pending }
    private func status(for i: Int) -> Status {
        if i < currentIndex { return .done }
        if i == currentIndex { return .active }
        return .pending
    }

    @ViewBuilder
    private func segment(index: Int, step: StepDefinition, status: Status) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(String(format: "%02d", index + 1))
                .font(.system(size: 9, weight: .regular, design: .monospaced))
                .tracking(2)
                .foregroundStyle(color(for: status).opacity(0.7))
            Text((status == .done ? "✓ " : status == .active ? "▶ " : "") + step.label.uppercased())
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(textColor(for: status))
        }
        .frame(minWidth: 96, alignment: .leading)
        .padding(.vertical, 7).padding(.horizontal, 12)
        .background(background(for: status))
        .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(border(for: status), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: status == .active ? Color.yellow.opacity(0.45) : .clear, radius: 8)
    }

    private func color(for s: Status) -> Color {
        switch s { case .done: .green; case .active: .yellow; case .pending: .gray }
    }
    private func textColor(for s: Status) -> Color {
        switch s { case .done: .green; case .active: .white; case .pending: Color(white: 0.25) }
    }
    private func background(for s: Status) -> Color {
        switch s {
        case .done:    return Color(red: 0.02, green: 0.17, blue: 0.12)
        case .active:  return Color(red: 0.10, green: 0.05, blue: 0.18)
        case .pending: return Color(red: 0.055, green: 0.055, blue: 0.086)
        }
    }
    private func border(for s: Status) -> Color {
        switch s {
        case .done:    return Color(red: 0.04, green: 0.29, blue: 0.21)
        case .active:  return .yellow
        case .pending: return Color(red: 0.10, green: 0.10, blue: 0.15)
        }
    }
}
