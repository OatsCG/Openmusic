//
//  FetchedArtistContentHeader_faero.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct FetchedArtistContentHeader_faero: View {
    var artist: FetchedArtist
    //@State private var animate = false
    @State private var currID: Double = 0
    var body: some View {
        ArtistPageImageDisplay(ArtworkID: artist.Profile_Photo, Resolution: .hd, Blur: 8, BlurOpacity: 0.6, cornerRadius: 12)
            .overlay {
                AeroGlossOverlay(baseCornerRadius: 12, padding: 5)
            }
        HStack {
            Text(artist.Name)
                .customFont(.largeTitle, bold: true)
                .multilineTextAlignment(.leading)
//                .foregroundAddition {
//                    ZStack {
//                        AlbumArtDisplay(ArtworkID: artist.Albums[Int(round(currID))].Artwork, Resolution: 240, Blur: 0, BlurOpacity: 0, cornerRadius: 0)
//                            .scaledToFill()
//                        
//                    }
//                }
            Spacer()
        }
            .padding(.horizontal, 10)
            .padding(.bottom, 16)
//            .onAppear {
//                withAnimation(.linear(duration: 10)) {
//                    currID = currID + 5
//                }
//            }
        
    }
}

#Preview {
    ScrollView {
        FetchedArtistContentHeader_faero(artist: FetchedArtist(default: true))
    }
}
