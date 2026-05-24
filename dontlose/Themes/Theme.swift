import SwiftUI

protocol Theme {
    var id: ThemeID { get }
    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView
    func makeStageView(viewModel: SessionViewModel) -> AnyView
    var soundPackID: String { get }
}
