//
//  glosstest.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-15.
//

import SwiftUI

struct glosstest: View {
    var body: some View {
        ScrollView {
            VStack {
                    //.frame(width: 150, height: 180)
                AlbumArtDisplay(ArtworkID: "8usgR3T9K3vQGp5F4W7H8edO08sYqegfR4NOTJbmwg2ekAZ3Kn66KjWgfQtLWMdpYpw2ZrCZeev0gB5pzQ", Resolution: .tile, Blur: 0, BlurOpacity: 0, cornerRadius: 15)
                    .frame(width: 200, height: 200)
                    //.padding(50)
                    .foregroundStyle(.primary)
                    .overlay {
                        AeroGlossOverlay(baseCornerRadius: 15, padding: 0)
                    }
                HStack {
                    Text("Album Name")
                    Spacer()
                }
                Spacer()
            }
                .frame(width: 200, height: 230)
                .padding(10)
                .background {
                    AeroGlossBG(cornerRadius: 25)
                }
        }
    }
}

#Preview {
    glosstest()
}
