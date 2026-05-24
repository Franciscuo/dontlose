import AppKit

final class SoundEngine {
    var isMuted: Bool = false

    private let player: (SoundCue) -> Void

    init(player: ((SoundCue) -> Void)? = nil) {
        if let p = player { self.player = p }
        else {
            self.player = { _ in
                // No-op default — production playback happens via play(_:in:).
            }
        }
    }

    func play(_ cue: SoundCue, in pack: SoundPack) {
        guard !isMuted, let name = pack.sounds[cue] else { return }
        if let url = Bundle.main.url(forResource: name, withExtension: "wav")
                  ?? Bundle.main.url(forResource: name, withExtension: "mp3"),
           let sound = NSSound(contentsOf: url, byReference: true) {
            sound.play()
        } else if let sys = NSSound(named: NSSound.Name(name)) {
            sys.play()
        }
    }

    func handle(_ event: SessionEvent, pack: SoundPack) {
        guard !isMuted else { return }
        switch event {
        case .sessionStarted, .stepStarted:
            player(.stepStart)
        case .stepCompleted(_, wasManualSkip: true):
            player(.stepComplete)
        case .stepCompleted(_, wasManualSkip: false):
            player(.stepStart)
        case .warningFired:
            player(.warning)
        case .sessionComplete:
            player(.sessionComplete)
        case .paused, .resumed:
            break
        }
    }
}
