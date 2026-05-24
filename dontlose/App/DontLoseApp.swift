import SwiftUI

@main
struct DontLoseApp: App {
    var body: some Scene {
        WindowGroup("dontlose") {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("dontlose").font(.system(size: 48, weight: .heavy))
            Text("Don't lose to the clock.").foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
