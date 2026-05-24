import SwiftUI

struct Country: Identifiable, Equatable, Hashable {
    let code: String          // ISO-3, e.g. "COL"
    let name: String
    let shirt: Color
    let shorts: Color
    let sock: Color
    let flagBuilder: () -> AnyView
    var id: String { code }
    static func == (lhs: Country, rhs: Country) -> Bool { lhs.code == rhs.code }
    func hash(into h: inout Hasher) { h.combine(code) }
}
