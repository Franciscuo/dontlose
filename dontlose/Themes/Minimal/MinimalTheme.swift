import SwiftUI

struct MinimalTheme: Theme {
    let id: ThemeID = .minimal
    var soundPackID: String { "minimal" }
    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView { AnyView(EmptyView()) }
    func makeStageView(viewModel: SessionViewModel) -> AnyView { AnyView(Color.black) }
}
