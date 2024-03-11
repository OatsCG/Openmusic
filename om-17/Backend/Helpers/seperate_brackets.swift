//
//  seperate_brackets.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI

func separate_brackets(_ toSplit: String) -> (main: String, sub: String) {
    if let firstBracketIndex = toSplit.firstIndex(where: { $0 == "(" || $0 == "[" }) {
        if firstBracketIndex > toSplit.startIndex {
            let main = String(toSplit[..<firstBracketIndex]).trimmingCharacters(in: .whitespaces)
            let sub = String(toSplit[firstBracketIndex...])
            return (main, sub)
        } else {
            if let secondBracketIndex = toSplit[toSplit.index(after: firstBracketIndex)...].firstIndex(where: { $0 == "(" || $0 == "[" }) {
                let main = String(toSplit[..<secondBracketIndex]).trimmingCharacters(in: .whitespaces)
                let sub = String(toSplit[secondBracketIndex...])
                return (main, sub)
            }
        }
    }
    return (toSplit, "")
}

struct seperate_brackets_test: View {
    var albums: [String] = ["Look at me!", "?", "? (Deluxe)", "Spiderverse (Soundtrack) (deluxe)", "title (featuring) [remix (slowed)]", "my dillemma (extended) - EP", "(love): Single", "(love): Single (Deluxe)"]
    var body: some View {
        ForEach(albums, id: \.self) { title in
            let splittitle = separate_brackets(title)
            HStack {
                Text(splittitle.main)
                    .foregroundStyle(.red)
                Text(splittitle.sub)
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    seperate_brackets_test()
}
