import SwiftUI

struct BoxingTheme: Theme {
    let id: ThemeID = .boxing
    var soundPackID: String { "boxing" }
    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView { AnyView(EmptyView()) }
    func makeStageView(viewModel: SessionViewModel) -> AnyView { AnyView(Color.black) }
}
