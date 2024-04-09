//
//  QPPlaylistTracks.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-21.
//

import SwiftUI

struct QPPlaylistTracks: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    var items: [PlaylistItem]
    var body: some View {
        if items.isEmpty {
            HStack {
                Spacer()
                Text("No Songs Added")
                    .foregroundStyle(.secondary)
                Spacer()
            }
        } else {
            VStack(alignment: .leading, spacing: 10) {
                let sortedItems: [PlaylistItem] = sort_by_date(items: items).filter({ $0.importData.status == .success })
                let threeRecentItems: [PlaylistItem] = max_three(items: sortedItems)
                ForEach(Array(threeRecentItems.enumerated()), id: \.offset) {index, item in
                    Button(action: {
                        playerManager.fresh_play_multiple(tracks: sortedItems.suffix(from: index).map{$0.track})
                        //PlayerManager.shared.fresh_play(track: track)
                    }) {
                        HStack {
                            Text(item.track.Title)
                                .customFont(fontManager, .subheadline)
                                //.font(Font.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                    .contextMenu {
                        TrackMenu(track: item.track)
                            .environment(fontManager)
                    } preview: {
                        TrackMenuPreview_component(track: item.track)
                            .environment(fontManager)
                    }
                    if (index < items.filter({ $0.importData.status == .success }).count) {
                        Divider()
                            .opacity(0.8)
                    }
                }
            }
        }
    }
    private func sort_by_date(items: [PlaylistItem]) -> [PlaylistItem] {
        return items.sorted{Int($0.importData.dateAdded.timeIntervalSince1970) > Int($1.importData.dateAdded.timeIntervalSince1970)}
    }

    private func max_three(items: [PlaylistItem]) -> [PlaylistItem] {
        return Array(items.prefix(3))
    }
}


