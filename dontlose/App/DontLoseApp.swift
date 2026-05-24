import SwiftUI

@main
struct DontLoseApp: App {
    @StateObject private var router = AppRouter()
    var body: some Scene {
        WindowGroup("dontlose") {
            RootView()
                .environmentObject(router)
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowResizability(.contentSize)
    }
}

struct RootView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        switch router.route {
        case .setup:              SetupView()
        case .session(let cfg):   SessionView(config: cfg)
        case .complete(let cfg):  SessionCompleteView(config: cfg)
        }
    }
}
