import SwiftUI

struct SessionView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var vm: SessionViewModel
    private let theme: Theme
    private let sound: SoundEngine
    private let pack: SoundPack

    init(config: SessionConfig) {
        let vm = SessionViewModel(config: config, tickProvider: DispatchSourceTickProvider())
        _vm = StateObject(wrappedValue: vm)
        let chosen = ThemeRegistry.theme(for: config.theme) ?? MinimalTheme()
        self.theme = chosen
        self.sound = SoundEngine()
        self.pack = SoundPack.forID(chosen.soundPackID)
    }

    var body: some View {
        ZStack {
            theme.makeStageView(viewModel: vm)
            HUDView(vm: vm)
            VStack { Spacer(); controlsBar }
        }
        .ignoresSafeArea()
        .onAppear {
            sound.isMuted = router.settings.masterMute
            vm.onEvent = { [weak vm] event in
                guard let vm else { return }
                sound.play(soundCue(for: event), in: pack)
                if case .sessionComplete = event {
                    router.sessionDidComplete(cfg: vm.state.config)
                }
            }
            vm.start()
        }
        .background(Color.black)
        .focusable()
        .onKeyPress(.space) {
            vm.state.isPaused ? vm.resume() : vm.pause()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            vm.skipStep()
            return .handled
        }
        .onKeyPress(KeyEquivalent("r")) {
            vm.restart()
            return .handled
        }
    }

    private func soundCue(for event: SessionEvent) -> SoundCue {
        switch event {
        case .sessionStarted, .stepStarted:                       return .stepStart
        case .stepCompleted(_, wasManualSkip: true):              return .stepComplete
        case .stepCompleted(_, wasManualSkip: false):             return .stepStart
        case .warningFired:                                       return .warning
        case .sessionComplete:                                    return .sessionComplete
        case .paused, .resumed:                                   return .ambient
        }
    }

    @ViewBuilder
    private var controlsBar: some View {
        HStack(spacing: 10) {
            Button(vm.state.isPaused ? "Resume" : "Pause") {
                vm.state.isPaused ? vm.resume() : vm.pause()
            }
            Button("Skip step") { vm.skipStep() }
            Button("Restart")   { vm.restart() }
            Spacer()
            Button("End session") { router.backToSetup() }
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .padding(.horizontal, 18).padding(.bottom, 56)
    }
}
