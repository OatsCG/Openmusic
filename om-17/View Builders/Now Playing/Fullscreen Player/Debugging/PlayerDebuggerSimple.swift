//
//  PlayerDebuggerSimple.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-14.
//

import SwiftUI

struct PlayerDebuggerSimple: View {
    @State var visible: Bool
    @State var text: String
    @State var symbol: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Image(systemName: symbol)
                    Text(text)
                }
                .buttonStyle(.plain)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                .shadow(radius: 5)
            }
        }
        .font(.caption2)
        .lineLimit(1)
        .padding(10)
        .opacity(visible ? 1.0 : 0.0)
    }
}
