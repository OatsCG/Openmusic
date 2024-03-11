//
//  BlurredText.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-04.
//

import SwiftUI

extension View {
    public func foregroundBlur(ArtworkID: String, fade: Double = 0.4) -> some View {
        self
            .foregroundStyle(.clear)
            .background {
                ZStack {
                    AlbumBackground(ArtworkID: ArtworkID, blur: 50, light_opacity: 1, dark_opacity: 1, spin: false, saturate: true)
                    Color.primary.opacity(fade)
                }
                
            }
            .mask {
                self
                    .padding(-1)
            }
    }
    func foregroundBlur(playlist: Playlist, fade: Double = 0.4) -> some View {
        self
            .foregroundStyle(.clear)
            .background {
                ZStack {
                    PlaylistBackground(playlist: playlist, blur: 50, light_opacity: 1, dark_opacity: 1, spin: false, saturate: true)
                    Color.primary.opacity(fade)
                }
                    .allowsHitTesting(false)
                
            }
            .mask {
                self
                    .padding(-1)
            }
    }
    public func foregroundAddition<V>(@ViewBuilder content: () -> V) -> some View where V : View {
        self
            .foregroundStyle(.clear)
            .background {
                content()
                    //.allowsHitTesting(false)
            }
            .mask {
                self
                    .padding(-1)
            }
    }
}




#Preview {
    VStack {
        Text("This Is Acting (Deluxe Version)")
            .customFont(.title, bold: true)
            //.border(.white)
            .foregroundBlur(ArtworkID: "FVx7pMdJR9PEYdz9QRDkZM94tZ8B0tr_U2ONcgsUf2We8sIkmOBys_X63U1d7DU6NgJ9ljAmWAxJPnUE")
            //.border(.blue)
            .multilineTextAlignment(.center)
    }
    .safeAreaPadding(.horizontal, 20)
}

#Preview {
    AlbumContentHeading_classic(album: SearchedAlbum())
}

#Preview {
    VStack {
        Text("This Is Acting (Deluxe Version)")
            .customFont(.title, bold: true)
            .foregroundAddition {
                Color.red
            }
    }
}
