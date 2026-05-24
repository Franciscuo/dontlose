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

private struct WorldCupStageView: View {
    @ObservedObject var vm: SessionViewModel
    var body: some View {
        SpriteView(scene: makeScene(), options: [.allowsTransparency])
            .ignoresSafeArea()
    }
    private func makeScene() -> SKScene {
        let s = WorldCupScene(size: CGSize(width: 1200, height: 700))
        s.vm = vm
        s.configure(yourTeam: vm.state.config.themeOptions.yourTeam,
                    opponent: vm.state.config.themeOptions.opponentTeam)
        return s
    }
}
