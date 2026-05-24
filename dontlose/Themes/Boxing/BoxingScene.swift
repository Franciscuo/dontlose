import SpriteKit
import Combine

final class BoxingScene: SKScene {
    weak var vm: SessionViewModel?
    private var cancellable: AnyCancellable?

    private var leftFighter: SKNode!
    private var rightFighter: SKNode!
    private var bell: SKLabelNode!
    private var pow: SKLabelNode!
    private var crowdLayer: SKNode!
    private var cornerLeftColor: NSColor = .systemRed
    private var cornerRightColor: NSColor = .systemBlue

    override func didMove(to view: SKView) {
        backgroundColor = NSColor(red: 0.04, green: 0.03, blue: 0.09, alpha: 1)
        scaleMode = .resizeFill
        buildCrowd()
        buildRing()
        buildFighters()
        buildBell()
        buildPow()
        startIdleLoop()
        subscribeToViewModel()
    }

    func configure(cornerColor: String) {
        switch cornerColor {
        case "blue":   cornerLeftColor = .systemBlue;   cornerRightColor = .systemRed
        case "green":  cornerLeftColor = .systemGreen;  cornerRightColor = .systemOrange
        case "yellow": cornerLeftColor = .systemYellow; cornerRightColor = .systemPurple
        default:       cornerLeftColor = .systemRed;    cornerRightColor = .systemBlue
        }
    }

    private func subscribeToViewModel() {
        guard let vm = vm else { return }
        cancellable = vm.$state
            .map(\.lastEvent)
            .removeDuplicates()
            .sink { [weak self] event in self?.react(to: event) }
    }

    private func react(to event: SessionEvent) {
        switch event {
        case .stepStarted:
            playStepTransition()
        case .stepCompleted(_, let wasManualSkip):
            if wasManualSkip { playStepComplete() }
        case .sessionComplete:
            playSessionComplete()
        case .warningFired:
            playWarningPulse()
        default:
            break
        }
    }

    private func playStepTransition() {
        let actions: [SKAction] = [
            SKAction.rotate(byAngle: -CGFloat.pi / 8, duration: 0.06),
            SKAction.rotate(byAngle:  CGFloat.pi / 4, duration: 0.06),
            SKAction.rotate(byAngle: -CGFloat.pi / 8, duration: 0.06),
        ]
        bell.run(SKAction.sequence(actions))
    }

    private func playStepComplete() {
        pow.alpha = 0
        pow.setScale(0.1)
        pow.run(.sequence([
            .group([.fadeIn(withDuration: 0.1), .scale(to: 1.3, duration: 0.1)]),
            .wait(forDuration: 0.5),
            .group([.fadeOut(withDuration: 0.3), .scale(to: 0.8, duration: 0.3)]),
        ]))
    }

    private func playWarningPulse() {
        let pulse = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        pulse.fillColor = .systemRed; pulse.alpha = 0; pulse.strokeColor = .clear
        addChild(pulse)
        pulse.run(.sequence([.fadeAlpha(to: 0.15, duration: 0.1), .fadeOut(withDuration: 0.4), .removeFromParent()]))
    }

    private func playSessionComplete() {
        let ko = SKLabelNode(fontNamed: "Impact")
        ko.text = "K.O."
        ko.fontSize = 96
        ko.fontColor = .yellow
        ko.position = .init(x: size.width/2, y: size.height/2)
        ko.alpha = 0
        addChild(ko)
        ko.run(.sequence([
            .fadeIn(withDuration: 0.3),
            .wait(forDuration: 2.0),
            .fadeOut(withDuration: 0.4),
            .removeFromParent()
        ]))
    }

    private func buildCrowd() {
        crowdLayer = SKNode(); addChild(crowdLayer)
        let colors: [NSColor] = [.white, .yellow, .systemPink, .systemTeal]
        for _ in 0..<60 {
            let dot = SKShapeNode(circleOfRadius: 5)
            dot.fillColor = colors.randomElement()!.withAlphaComponent(0.55)
            dot.strokeColor = .clear
            dot.position = .init(x: .random(in: 0...size.width), y: .random(in: (size.height*0.55)...(size.height*0.92)))
            let bob = SKAction.sequence([.moveBy(x: 0, y: 4, duration: 0.6), .moveBy(x: 0, y: -4, duration: 0.6)])
            dot.run(.repeatForever(bob))
            crowdLayer.addChild(dot)
        }
    }

    private func buildRing() {
        let floor = SKShapeNode(rect: CGRect(x: size.width*0.08, y: size.height*0.12, width: size.width*0.84, height: size.height*0.36), cornerRadius: 6)
        floor.fillColor = NSColor(red: 0.16, green: 0.04, blue: 0.30, alpha: 1); floor.strokeColor = .clear
        addChild(floor)
        for off: CGFloat in [0, 18, 36] {
            let rope = SKShapeNode(rect: CGRect(x: size.width*0.08, y: size.height*0.12 + size.height*0.36 - off - 8, width: size.width*0.84, height: 2))
            rope.fillColor = .systemYellow; rope.strokeColor = .clear
            addChild(rope)
        }
        for x: CGFloat in [size.width*0.06, size.width*0.92 - 8] {
            let post = SKShapeNode(rect: CGRect(x: x, y: size.height*0.12, width: 14, height: size.height*0.36), cornerRadius: 3)
            post.fillColor = (x < size.width/2 ? cornerLeftColor : cornerRightColor); post.strokeColor = .clear
            addChild(post)
        }
    }

    private func buildFighters() {
        leftFighter  = makeFighter(color: cornerLeftColor)
        rightFighter = makeFighter(color: cornerRightColor)
        leftFighter.position  = .init(x: size.width*0.30, y: size.height*0.18)
        rightFighter.position = .init(x: size.width*0.70, y: size.height*0.18)
        rightFighter.xScale = -1
        addChild(leftFighter); addChild(rightFighter)
    }

    private func makeFighter(color: NSColor) -> SKNode {
        let node = SKNode()
        let body = SKShapeNode(rectOf: .init(width: 36, height: 60), cornerRadius: 6)
        body.fillColor = .init(red: 0.10, green: 0.10, blue: 0.18, alpha: 1); body.strokeColor = .clear
        body.position = .init(x: 0, y: 30); node.addChild(body)
        let trunks = SKShapeNode(rectOf: .init(width: 36, height: 18))
        trunks.fillColor = color; trunks.strokeColor = .clear
        trunks.position = .init(x: 0, y: 9); node.addChild(trunks)
        let head = SKShapeNode(circleOfRadius: 14)
        head.fillColor = .init(red: 0.96, green: 0.83, blue: 0.69, alpha: 1); head.strokeColor = .clear
        head.position = .init(x: 0, y: 72); node.addChild(head)
        return node
    }

    private func buildBell() {
        bell = SKLabelNode(text: "🔔")
        bell.fontSize = 28
        bell.position = .init(x: size.width - 36, y: size.height - 60)
        addChild(bell)
    }

    private func buildPow() {
        pow = SKLabelNode(fontNamed: "Impact")
        pow.text = "POW!"
        pow.fontSize = 56
        pow.fontColor = .systemYellow
        pow.position = .init(x: size.width/2, y: size.height*0.42)
        pow.alpha = 0
        addChild(pow)
    }

    private func startIdleLoop() {
        let bob = SKAction.sequence([.moveBy(x: 0, y: 5, duration: 0.5), .moveBy(x: 0, y: -5, duration: 0.5)])
        leftFighter.run(.repeatForever(bob))
        rightFighter.run(.repeatForever(.sequence([.wait(forDuration: 0.2), bob])))
    }
}
