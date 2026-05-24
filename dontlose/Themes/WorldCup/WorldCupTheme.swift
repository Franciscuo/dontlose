import SwiftUI
import SpriteKit

struct WorldCupTheme: Theme {
    let id: ThemeID = .worldCup
    var soundPackID: String { "worldCup" }

    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView {
        AnyView(CountryPicker(your: options.yourTeam, opponent: options.opponentTeam))
    }

    func makeStageView(viewModel: SessionViewModel) -> AnyView {
        AnyView(WorldCupStageView(vm: viewModel))
    }
}

@MainActor
private final class WorldCupSceneHolder: ObservableObject {
    let scene: WorldCupScene
    init(vm: SessionViewModel) {
        let s = WorldCupScene(size: CGSize(width: 1200, height: 700))
        s.vm = vm
        s.configure(yourTeam: vm.state.config.themeOptions.yourTeam,
                    opponent: vm.state.config.themeOptions.opponentTeam)
        scene = s
    }
}

private struct WorldCupStageView: View {
    @StateObject private var holder: WorldCupSceneHolder

    init(vm: SessionViewModel) {
        _holder = StateObject(wrappedValue: WorldCupSceneHolder(vm: vm))
    }

    var body: some View {
        SpriteView(scene: holder.scene, options: [.allowsTransparency])
            .ignoresSafeArea()
    }
}
