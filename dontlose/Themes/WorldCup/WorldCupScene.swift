import SpriteKit
import SwiftUI
import Combine

final class WorldCupScene: SKScene {
    weak var vm: SessionViewModel?
    private var cancellable: AnyCancellable?

    private var ball: SKShapeNode!
    private var playerLeft: SKNode!
    private var playerRight: SKNode!
    private var crowdLayer: SKNode!
    private var teamLeftCode: String = "COL"
    private var teamRightCode: String = "FRA"

    override func didMove(to view: SKView) {
        backgroundColor = NSColor(red: 0.04, green: 0.24, blue: 0.18, alpha: 1)
        scaleMode = .resizeFill
        buildSky()
        buildCrowd()
        buildPitch()
        buildPlayers()
        buildBall()
        startPassingLoop()
        subscribeToViewModel()
    }

    func configure(yourTeam: String, opponent: String) {
        teamLeftCode = yourTeam
        teamRightCode = opponent
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
        case .stepStarted:                            playStepTransition()
        case .stepCompleted(_, wasManualSkip: true):  playStepComplete()
        case .sessionComplete:                        playSessionComplete()
        case .warningFired:                           playWarningPulse()
        default: break
        }
    }

    private func playStepTransition() {
        let flash = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        flash.fillColor = .white; flash.alpha = 0; flash.strokeColor = .clear
        addChild(flash)
        flash.run(.sequence([.fadeAlpha(to: 0.18, duration: 0.08), .fadeOut(withDuration: 0.25), .removeFromParent()]))
    }

    private func playStepComplete() {
        let emitter = makeConfetti()
        emitter.position = .init(x: size.width/2, y: size.height/2)
        addChild(emitter)
        emitter.run(.sequence([.wait(forDuration: 1.6), .removeFromParent()]))
    }

    private func playWarningPulse() {
        let pulse = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        pulse.fillColor = .systemYellow; pulse.alpha = 0; pulse.strokeColor = .clear
        addChild(pulse)
        pulse.run(.sequence([.fadeAlpha(to: 0.12, duration: 0.1), .fadeOut(withDuration: 0.4), .removeFromParent()]))
    }

    private func playSessionComplete() {
        let trophy = SKLabelNode(text: "🏆")
        trophy.fontSize = 96
        trophy.position = .init(x: size.width/2, y: -50)
        addChild(trophy)
        trophy.run(.sequence([
            .moveTo(y: size.height/2, duration: 0.6),
            .group([.scale(to: 1.3, duration: 0.3), .rotate(byAngle: .pi/12, duration: 0.3)]),
            .wait(forDuration: 1.8),
            .fadeOut(withDuration: 0.4),
            .removeFromParent()
        ]))
    }

    private func buildSky() {
        let g = SKShapeNode(rect: CGRect(x: 0, y: size.height*0.55, width: size.width, height: size.height*0.45))
        g.fillColor = NSColor(red: 0.04, green: 0.24, blue: 0.18, alpha: 1); g.strokeColor = .clear
        addChild(g)
    }

    private func buildCrowd() {
        crowdLayer = SKNode(); addChild(crowdLayer)
        let people = 240
        for i in 0..<people {
            let person = makePerson(seed: i)
            let col = i % 30, row = i / 30
            person.position = .init(
                x: CGFloat(col) * (size.width/30) + 8,
                y: size.height*0.55 + 8 + CGFloat(row) * 14
            )
            crowdLayer.addChild(person)
        }
    }

    private func makePerson(seed: Int) -> SKNode {
        let n = SKNode()
        let skin: NSColor = [NSColor(red: 0.96, green: 0.83, blue: 0.69, alpha:1),
                             NSColor(red: 0.84, green: 0.64, blue: 0.48, alpha:1),
                             NSColor(red: 0.61, green: 0.42, blue: 0.24, alpha:1),
                             NSColor(red: 0.42, green: 0.27, blue: 0.15, alpha:1)][seed % 4]
        let shirts: [NSColor] = [.systemPink, .systemTeal, .systemGreen, .systemYellow, .systemPurple, .white]
        let shirt = shirts[seed % 6]
        let head = SKShapeNode(circleOfRadius: 3); head.fillColor = skin; head.strokeColor = .clear
        head.position = .init(x: 0, y: 6); n.addChild(head)
        let body = SKShapeNode(rectOf: .init(width: 8, height: 8), cornerRadius: 1); body.fillColor = shirt; body.strokeColor = .clear
        n.addChild(body)
        if seed % 8 == 0 {
            let flag = SKShapeNode(rectOf: .init(width: 8, height: 6))
            flag.fillColor = ([NSColor.systemYellow, .systemBlue, .systemRed, .white, .systemGreen].randomElement() ?? .systemYellow)
            flag.strokeColor = NSColor.black.withAlphaComponent(0.4)
            flag.position = .init(x: 6, y: 10)
            let wave = SKAction.sequence([.rotate(byAngle: 0.2, duration: 0.6), .rotate(byAngle: -0.2, duration: 0.6)])
            flag.run(.repeatForever(wave))
            n.addChild(flag)
        }
        let bob = SKAction.sequence([.moveBy(x: 0, y: 2, duration: 0.8), .moveBy(x: 0, y: -2, duration: 0.8)])
        n.run(.repeatForever(bob))
        return n
    }

    private func buildPitch() {
        let pitch = SKShapeNode(rectOf: .init(width: size.width*0.88, height: size.height*0.42), cornerRadius: 6)
        pitch.position = .init(x: size.width/2, y: size.height*0.27)
        pitch.fillColor = NSColor(red: 0.17, green: 0.56, blue: 0.30, alpha: 1)
        pitch.strokeColor = NSColor.white.withAlphaComponent(0.85)
        pitch.lineWidth = 3
        addChild(pitch)
        let center = SKShapeNode(circleOfRadius: 40)
        center.position = pitch.position
        center.strokeColor = NSColor.white.withAlphaComponent(0.85); center.lineWidth = 3; center.fillColor = .clear
        addChild(center)
    }

    private func buildPlayers() {
        let leftCountry  = CountryRegistry.country(for: teamLeftCode)
        let rightCountry = CountryRegistry.country(for: teamRightCode)
        playerLeft  = makePlayer(country: leftCountry)
        playerRight = makePlayer(country: rightCountry)
        playerLeft.position  = .init(x: size.width*0.22, y: size.height*0.18)
        playerRight.position = .init(x: size.width*0.78, y: size.height*0.18)
        playerRight.xScale = -1
        addChild(playerLeft); addChild(playerRight)
    }

    private func makePlayer(country: Country) -> SKNode {
        let n = SKNode()
        let shirt = SKShapeNode(rectOf: .init(width: 30, height: 24), cornerRadius: 3)
        shirt.fillColor = NSColor(country.shirt); shirt.strokeColor = .clear
        shirt.position = .init(x: 0, y: 30); n.addChild(shirt)
        let shorts = SKShapeNode(rectOf: .init(width: 28, height: 14))
        shorts.fillColor = NSColor(country.shorts); shorts.strokeColor = .clear
        shorts.position = .init(x: 0, y: 12); n.addChild(shorts)
        let head = SKShapeNode(circleOfRadius: 9)
        head.fillColor = .init(red: 0.96, green: 0.83, blue: 0.69, alpha: 1); head.strokeColor = .clear
        head.position = .init(x: 0, y: 50); n.addChild(head)
        return n
    }

    private func buildBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.fillColor = .white; ball.strokeColor = .black; ball.lineWidth = 1
        ball.position = .init(x: size.width*0.22, y: size.height*0.15)
        addChild(ball)
    }

    private func startPassingLoop() {
        let toRight = SKAction.move(to: CGPoint(x: size.width*0.78, y: size.height*0.15), duration: 1.4)
        let toLeft  = SKAction.move(to: CGPoint(x: size.width*0.22, y: size.height*0.15), duration: 1.4)
        let arcUp   = SKAction.sequence([.moveBy(x: 0, y: 40, duration: 0.7), .moveBy(x: 0, y: -40, duration: 0.7)])
        let cycle = SKAction.sequence([
            .group([toRight, arcUp]),
            .wait(forDuration: 0.2),
            .group([toLeft, arcUp]),
            .wait(forDuration: 0.2),
        ])
        ball.run(.repeatForever(cycle))
    }

    private func makeConfetti() -> SKEmitterNode {
        let e = SKEmitterNode()
        e.particleTexture = nil
        e.particleBirthRate = 600
        e.numParticlesToEmit = 200
        e.particleLifetime = 1.4
        e.particleSpeed = 200
        e.particleSpeedRange = 80
        e.emissionAngle = .pi/2
        e.emissionAngleRange = .pi
        e.particleScale = 0.4
        e.particleColorBlendFactor = 1
        e.particleColor = .systemYellow
        e.particleColorSequence = SKKeyframeSequence(keyframeValues: [
            NSColor.systemRed, NSColor.systemYellow, NSColor.systemBlue, NSColor.systemGreen
        ], times: [0, 0.33, 0.66, 1])
        e.particleAlpha = 0.95
        e.particleAlphaSpeed = -0.7
        return e
    }
}
