import SwiftUI

enum CountryRegistry {
    static let all: [Country] = [
        .init(code: "COL", name: "Colombia", shirt: Color(red: 0.99, green: 0.82, blue: 0.09),
              shorts: Color(red: 0.00, green: 0.22, blue: 0.58), sock: Color(red: 0.81, green: 0.07, blue: 0.15),
              flagBuilder: { AnyView(VStack(spacing: 0) {
                  Rectangle().fill(Color(red: 0.99, green: 0.82, blue: 0.09)).frame(height: 14)
                  Rectangle().fill(Color(red: 0.00, green: 0.22, blue: 0.58)).frame(height: 7)
                  Rectangle().fill(Color(red: 0.81, green: 0.07, blue: 0.15)).frame(height: 7)
              }) }),
        .init(code: "FRA", name: "France", shirt: Color(red: 0.00, green: 0.15, blue: 0.33),
              shorts: .white, sock: Color(red: 0.81, green: 0.07, blue: 0.15),
              flagBuilder: { AnyView(HStack(spacing: 0) {
                  Rectangle().fill(Color(red: 0.00, green: 0.15, blue: 0.33))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.81, green: 0.07, blue: 0.15))
              }) }),
        .init(code: "BRA", name: "Brazil", shirt: Color(red: 1.0, green: 0.87, blue: 0.0),
              shorts: Color(red: 0.0, green: 0.5, blue: 0.31), sock: .white,
              flagBuilder: { AnyView(ZStack {
                  Rectangle().fill(Color(red: 0.0, green: 0.61, blue: 0.23))
                  Circle().fill(Color(red: 1.0, green: 0.87, blue: 0.0)).padding(4)
              }) }),
        .init(code: "ARG", name: "Argentina", shirt: Color(red: 0.46, green: 0.67, blue: 0.86),
              shorts: .black, sock: .white,
              flagBuilder: { AnyView(VStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.46, green: 0.67, blue: 0.86))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.46, green: 0.67, blue: 0.86))
              }) }),
        .init(code: "GER", name: "Germany", shirt: .white, shorts: .black, sock: .white,
              flagBuilder: { AnyView(VStack(spacing:0) {
                  Rectangle().fill(Color.black)
                  Rectangle().fill(Color(red: 0.87, green: 0.0, blue: 0.0))
                  Rectangle().fill(Color(red: 1.0, green: 0.81, blue: 0.0))
              }) }),
        .init(code: "ESP", name: "Spain", shirt: Color(red: 0.67, green: 0.08, blue: 0.10),
              shorts: Color(red: 0.0, green: 0.13, blue: 0.39), sock: .black,
              flagBuilder: { AnyView(VStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.67, green: 0.08, blue: 0.10)).frame(maxHeight: 6)
                  Rectangle().fill(Color(red: 0.95, green: 0.75, blue: 0.0))
                  Rectangle().fill(Color(red: 0.67, green: 0.08, blue: 0.10)).frame(maxHeight: 6)
              }) }),
        .init(code: "ITA", name: "Italy", shirt: Color(red: 0.0, green: 0.36, blue: 0.27),
              shorts: .white, sock: Color(red: 0.81, green: 0.17, blue: 0.22),
              flagBuilder: { AnyView(HStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.0, green: 0.57, blue: 0.27))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.81, green: 0.17, blue: 0.22))
              }) }),
        .init(code: "ENG", name: "England", shirt: .white, shorts: Color(red:0.0,green:0.13,blue:0.39), sock: .white,
              flagBuilder: { AnyView(ZStack {
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.81, green: 0.07, blue: 0.15)).frame(width: 6)
                  Rectangle().fill(Color(red: 0.81, green: 0.07, blue: 0.15)).frame(height: 6)
              }) }),
        .init(code: "JPN", name: "Japan", shirt: Color(red: 0.0, green: 0.13, blue: 0.39), shorts: .white, sock: Color(red: 0.0, green: 0.13, blue: 0.39),
              flagBuilder: { AnyView(ZStack {
                  Rectangle().fill(Color.white)
                  Circle().fill(Color(red: 0.74, green: 0.0, blue: 0.18)).padding(8)
              }) }),
        .init(code: "MEX", name: "Mexico", shirt: Color(red: 0.0, green: 0.41, blue: 0.27), shorts: .white, sock: Color(red: 0.81, green: 0.07, blue: 0.15),
              flagBuilder: { AnyView(HStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.0, green: 0.41, blue: 0.27))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.81, green: 0.07, blue: 0.15))
              }) }),
        .init(code: "USA", name: "United States", shirt: .white, shorts: Color(red: 0.0, green: 0.13, blue: 0.39), sock: .white,
              flagBuilder: { AnyView(VStack(spacing:0) { ForEach(0..<6) { i in Rectangle().fill(i%2==0 ? Color(red:0.7,green:0.13,blue:0.20) : Color.white) } }) }),
        .init(code: "CAN", name: "Canada", shirt: Color(red: 0.85, green: 0.0, blue: 0.15), shorts: .white, sock: Color(red: 0.85, green: 0.0, blue: 0.15),
              flagBuilder: { AnyView(HStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.85, green: 0.0, blue: 0.15))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.85, green: 0.0, blue: 0.15))
              }) }),
        .init(code: "NGA", name: "Nigeria", shirt: Color(red: 0.0, green: 0.53, blue: 0.32), shorts: .white, sock: Color(red: 0.0, green: 0.53, blue: 0.32),
              flagBuilder: { AnyView(HStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.0, green: 0.53, blue: 0.32))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.0, green: 0.53, blue: 0.32))
              }) }),
        .init(code: "IND", name: "India", shirt: .orange, shorts: .white, sock: .green,
              flagBuilder: { AnyView(VStack(spacing:0) {
                  Rectangle().fill(Color(red: 1.0, green: 0.6, blue: 0.2))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.07, green: 0.53, blue: 0.03))
              }) }),
        .init(code: "KEN", name: "Kenya", shirt: Color(red: 0.0, green: 0.53, blue: 0.32), shorts: Color(red:0.78,green:0.0,blue:0.0), sock: .black,
              flagBuilder: { AnyView(VStack(spacing:0) {
                  Rectangle().fill(Color.black)
                  Rectangle().fill(Color(red: 0.78, green: 0.0, blue: 0.0))
                  Rectangle().fill(Color(red: 0.03, green: 0.53, blue: 0.19))
              }) }),
        .init(code: "PER", name: "Peru", shirt: Color(red:0.78,green:0.0,blue:0.0), shorts: .white, sock: Color(red:0.78,green:0.0,blue:0.0),
              flagBuilder: { AnyView(HStack(spacing:0) {
                  Rectangle().fill(Color(red: 0.78, green: 0.0, blue: 0.0))
                  Rectangle().fill(Color.white)
                  Rectangle().fill(Color(red: 0.78, green: 0.0, blue: 0.0))
              }) }),
    ]
    static func country(for code: String) -> Country {
        all.first(where: { $0.code == code }) ?? all.first!
    }
    static func random(excluding exclude: String) -> Country {
        all.filter { $0.code != exclude }.randomElement() ?? all.first!
    }
}
