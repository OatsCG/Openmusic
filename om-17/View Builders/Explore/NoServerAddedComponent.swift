//
//  NoServerAddedComponent.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-06-10.
//

import SwiftUI

struct NoServerAddedComponent: View {
    @Binding var showingServerSheet: Bool
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "network.slash")
                        .font(.largeTitle)
                        .scaleEffect(1.35)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                    Text("No Server Added")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text("Openmusic streams from custom servers.\nAdd a server to get started.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        showingServerSheet.toggle()
                    }) {
                        AlbumWideButton_component(text: "Add a Server", ArtworkID: "")
                            .frame(width: 200)
                    }
                }
                Spacer()
            }
            Spacer()
        }
    }
}
