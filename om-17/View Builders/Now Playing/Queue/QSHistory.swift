//
//  QSHistory.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-06.
//

import SwiftUI

struct QSHistory: View {
    @Environment(PlayerManager.self) var playerManager
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    var body: some View {
        if (playerManager.sessionHistory.count == 0) {
            VStack {
                Spacer()
                Text("Nothing in History")
                    .customFont(.title2)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        } else {
            List {
                ForEach(Array(playerManager.sessionHistory.enumerated()), id: \.element) { index, track in
                    QSQueueRow(queueItem: track, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet, isQueue: false)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    delete(at: IndexSet(integer: index))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.clear)
                        }
                }
                    .onMove(perform: move)
            }
                .background(Color.clear)
                .listStyle(PlainListStyle())
        }
    }
    private func move(from source: IndexSet, to destination: Int) {
        var updatedQueue = playerManager.sessionHistory
        updatedQueue.move(fromOffsets: source, toOffset: destination)
        playerManager.sessionHistory = updatedQueue
        Task {
            await playerManager.prime_next_song()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        var updatedQueue = playerManager.sessionHistory
        updatedQueue.remove(atOffsets: offsets)
        playerManager.sessionHistory = updatedQueue
        Task {
            await playerManager.prime_next_song()
        }
    }
}

//#Preview {
//    QSHistory()
//}
