//
//  PlaylistItemList.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI

struct PlaylistItemList: View {
    @Environment(PlayerManager.self) var playerManager
    var playlist: StoredPlaylist
    var body: some View {
        if playlist.items.isEmpty {
            ContentUnavailableView {
                Label("No Songs in Playlist", systemImage: "play.square.stack")
            } description: {
                Text("Music added to this playlist will appear here.")
            }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .listRowSeparator(.hidden)
        } else {
            ForEach(Array(playlist.items.enumerated()), id: \.offset) {index, item in
                PlaylistItemLink(item: item, playlist: playlist, index: index)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 2, trailing: 20))
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            playerManager.queue_song(track: item.track, explicit: item.explicit)
                        } label: {
                            Label("Queue Later", systemImage: "text.line.last.and.arrowtriangle.forward")
                        }
                        .tint(Color(.systemBackground))
                        Button {
                            playerManager.queue_next(track: item.track, explicit: item.explicit)
                        } label: {
                            Label("Queue Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                        }
                        .tint(Color(.systemBackground))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            delete(at: IndexSet(integer: index))
                        } label: {
                            Label("Remove from Playlist", systemImage: "minus.circle.fill")
                        }
                            .tint(.red)
                    }
            }
                .onMove(perform: move)
                .onDelete(perform: delete)
        }
    }
    private func move(from source: IndexSet, to destination: Int) {
        playlist.performMove(source: source, destination: destination)
    }
    func delete(at offsets: IndexSet) {
        withAnimation {
            playlist.items.remove(atOffsets: offsets)
        }
    }
}
