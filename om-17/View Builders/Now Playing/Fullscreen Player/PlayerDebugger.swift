//
//  PlayerDebugg.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-14.
//

import SwiftUI

struct PlayerDebugger: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("playerDebugger") var playerDebugger: Bool = false
    @State var visibleState: DebuggerState = .hidden
    var body: some View {
        if (playerDebugger == true) {
            PlayerDebuggerComplex(visibleState: $visibleState)
        } else {
            ZStack {
                PlayerDebuggerComplex(visibleState: $visibleState)
                    .opacity(0)
                switch visibleState {
                case .hidden:
                    EmptyView()
                case .noconnection:
                    PlayerDebuggerSimple(visible: true, text: "No Connection", symbol: "network.slash")
                case .fetcherror:
                    PlayerDebuggerSimple(visible: true, text: "Error Fetching Playback", symbol: "exclamationmark.triangle.fill")
                case .emptyplayback:
                    PlayerDebuggerSimple(visible: true, text: "Not Available For Streaming", symbol: "x.circle.fill")
                case .playererror:
                    PlayerDebuggerSimple(visible: true, text: "Player Failed", symbol: "x.circle.fill")
                case .fetching:
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 5) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                HStack(spacing: 5) {
                                    Circle().fill(colorScheme == .dark ? .white : .primary)
                                        .frame(width: 6, height: 6)
                                    Circle().fill(.tertiary)
                                        .frame(width: 6, height: 6)
                                }
                            }
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                        .font(.caption2)
                        .lineLimit(1)
                        .padding(10)
                case .buffering:
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 5) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                HStack(spacing: 5) {
                                    Circle().fill(colorScheme == .dark ? .white : .primary)
                                        .frame(width: 6, height: 6)
                                    Circle().fill(colorScheme == .dark ? .white : .primary)
                                        .frame(width: 6, height: 6)
                                }
                            }
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 3, topTrailingRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                        .font(.caption2)
                        .lineLimit(1)
                        .padding(10)
                }
            }
        }
    }
}

#Preview {
    PlayerDebugger()
}
