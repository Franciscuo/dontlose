import SwiftUI

struct WorldCupTheme: Theme {
    let id: ThemeID = .worldCup
    var soundPackID: String { "worldCup" }
    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView { AnyView(EmptyView()) }
    func makeStageView(viewModel: SessionViewModel) -> AnyView { AnyView(Color.black) }
}
