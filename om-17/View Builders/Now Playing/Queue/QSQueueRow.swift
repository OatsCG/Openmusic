//
//  QSQueueRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-21.
//

import SwiftUI
import MarqueeText

struct QSQueueRow: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(DownloadManager.self) var downloadManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State var queueItem: QueueItem
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    var isQueue: Bool
    
    var body: some View {
        Button(action: {
            // move to top of queue
            withAnimation {
                if (isQueue) {
                    playerManager.trackQueue.move(fromOffsets: IndexSet(integer: playerManager.trackQueue.firstIndex(where: {$0.queueID == queueItem.queueID}) ?? 0), toOffset: 0)
                } else {
                    playerManager.trackQueue.insert(queueItem, at: 0)
                    playerManager.sessionHistory.remove(at: playerManager.sessionHistory.firstIndex(where: {$0.queueID == queueItem.queueID}) ?? 0)
                }
                playerManager.player_forward()
            }
            // skip current song
        }) {
            HStack {
                AlbumArtDisplay(ArtworkID: queueItem.Track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 3)
                VStack(spacing: 0) {
                    MarqueeText(
                        text: queueItem.Track.Title,
                        font: FontManager.currentThemeUIFont(.headline, bold: true),
                        leftFade: 10,
                        rightFade: 10,
                        startDelay: 3
                    )
                    MarqueeText(
                        text: stringArtists(artistlist: queueItem.Track.Album.Artists),
                        font: FontManager.currentThemeUIFont(.subheadline),
                        leftFade: 10,
                        rightFade: 10,
                        startDelay: 3
                    )
                }
                Spacer()
                PlaybackExplicityDownloadedIcon(track: FetchedTrack(from: queueItem), explicit: queueItem.explicit)
                if let _ = queueItem.Track as? ImportedTrack {
                    QSQueueRowSparkle()
                } else {
                    Image(systemName: "line.3.horizontal")
                        .customFont(.title3)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 10)
                }
            }
                .padding(8)
                .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
                .background(.foreground.quaternary.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .contextMenu {
                    QueueItemMenu(queueItem: queueItem, passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                } preview: {
                    TrackMenuPreview_component(track: FetchedTrack(from: queueItem))
                }
        }
    }
}

//#Preview {
//    //NowPlayingSheet()
//    QueueSheet()
//}
