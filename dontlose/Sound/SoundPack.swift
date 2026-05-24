struct SoundPack: Equatable {
    let id: String
    let sounds: [SoundCue: String]

    static let minimal = SoundPack(id: "minimal", sounds: [
        .stepStart:       "Tink",
        .stepComplete:    "Pop",
        .warning:         "Ping",
        .sessionComplete: "Glass",
    ])
    static let boxing = SoundPack(id: "boxing", sounds: [
        .ambient:         "boxing_crowd_loop",
        .stepStart:       "boxing_bell",
        .stepComplete:    "boxing_thud",
        .warning:         "boxing_cornerman",
        .sessionComplete: "boxing_ko_roar",
    ])
    static let worldCup = SoundPack(id: "worldCup", sounds: [
        .ambient:         "wc_stadium_loop",
        .stepStart:       "wc_whistle",
        .stepComplete:    "wc_goal_horn",
        .warning:         "wc_crowd_surge",
        .sessionComplete: "wc_anthem",
    ])

    static func forID(_ id: String) -> SoundPack {
        switch id {
        case "boxing":   return .boxing
        case "worldCup": return .worldCup
        default:         return .minimal
        }
    }
}
