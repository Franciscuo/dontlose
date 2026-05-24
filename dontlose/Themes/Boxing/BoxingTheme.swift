import SwiftUI
import SpriteKit

struct BoxingTheme: Theme {
    let id: ThemeID = .boxing
    var soundPackID: String { "boxing" }

    func makeSetupAccessory(options: Binding<ThemeOptions>) -> AnyView {
        AnyView(CornerPicker(color: options.cornerColor))
    }

    func makeStageView(viewModel: SessionViewModel) -> AnyView {
        AnyView(BoxingStageView(vm: viewModel))
    }
}

private struct BoxingStageView: View {
    @ObservedObject var vm: SessionViewModel

    var body: some View {
        SpriteView(scene: makeScene(), options: [.allowsTransparency])
            .ignoresSafeArea()
    }

    private func makeScene() -> SKScene {
        let s = BoxingScene(size: CGSize(width: 1200, height: 700))
        s.vm = vm
        s.configure(cornerColor: vm.state.config.themeOptions.cornerColor)
        return s
    }
}
