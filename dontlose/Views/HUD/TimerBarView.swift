import SwiftUI

struct TimerBarView: View {
    /// 0.0 ... 1.0
    let fraction: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.18))
                Capsule()
                    .fill(LinearGradient(
                        colors: [.green, .yellow, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: max(0, geo.size.width * fraction))
                    .animation(.linear(duration: 0.95), value: fraction)
            }
        }
        .frame(height: 8)
    }
}
