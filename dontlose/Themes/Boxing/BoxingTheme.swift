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

@MainActor
private final class BoxingSceneHolder: ObservableObject {
    let scene: BoxingScene
    init(vm: SessionViewModel) {
        let s = BoxingScene(size: CGSize(width: 1200, height: 700))
        s.vm = vm
        s.configure(cornerColor: vm.state.config.themeOptions.cornerColor)
        scene = s
    }
}

private struct BoxingStageView: View {
    @StateObject private var holder: BoxingSceneHolder

    init(vm: SessionViewModel) {
        _holder = StateObject(wrappedValue: BoxingSceneHolder(vm: vm))
    }

    var body: some View {
        SpriteView(scene: holder.scene, options: [.allowsTransparency])
            .ignoresSafeArea()
    }
}
