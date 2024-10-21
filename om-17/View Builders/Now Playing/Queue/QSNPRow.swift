//
//  QSNowPlayingRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-21.
//

import SwiftUI
import MarqueeText

struct QSNPRow: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: playerManager.currentQueueItem?.Track.Album.Artwork, Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 3)
            VStack(spacing: 0) {
                if (playerManager.currentQueueItem == nil) {
                    MarqueeText(
                        text: "Nothing Playing",
                        font: FontManager.shared.currentThemeUIFont(fontManager, .headline, bold: true),
                        leftFade: 10,
                        rightFade: 10,
                        startDelay: 3
                    )
                    .foregroundStyle(.secondary)
                } else {
                    MarqueeText(
                        text: playerManager.currentQueueItem!.Track.Title,
                        font: FontManager.shared.currentThemeUIFont(fontManager, .headline, bold: true),
                        leftFade: 10,
                        rightFade: 10,
                        startDelay: 3
                    )
                    MarqueeText(
                        text: stringArtists(artistlist: playerManager.currentQueueItem!.Track.Album.Artists),
                        font: FontManager.shared.currentThemeUIFont(fontManager, .subheadline),
                        leftFade: 10,
                        rightFade: 10,
                        startDelay: 3
                    )
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
            QSNPRowControls()
        }
            .padding(8)
            .aspectRatio(CGFloat(TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).count / TrackLink_sizing(h: horizontalSizeClass, v: verticalSizeClass).span), contentMode: .fit)
            //.background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//#Preview {
//    //NowPlayingSheet()
//    QueueSheet()
//}
