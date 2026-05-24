import Foundation

protocol TickProvider: AnyObject {
    var onTick: (() -> Void)? { get set }
    func start()
    func stop()
}

final class DispatchSourceTickProvider: TickProvider {
    var onTick: (() -> Void)?
    private var timer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "dontlose.tick", qos: .userInteractive)
    func start() {
        stop()
        let t = DispatchSource.makeTimerSource(queue: queue)
        t.schedule(deadline: .now() + 1.0, repeating: 1.0)
        t.setEventHandler { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async { self.onTick?() }
        }
        timer = t
        t.resume()
    }
    func stop() { timer?.cancel(); timer = nil }
}

final class ManualTickProvider: TickProvider {
    var onTick: (() -> Void)?
    func start() {}
    func stop() {}
    func fire() { onTick?() }
}
