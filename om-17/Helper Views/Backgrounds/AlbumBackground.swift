//
//  AlbumBackground.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-22.
//

import SwiftUI

struct AlbumBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var ArtworkID: String?
    var blur: Double
    var light_opacity: Double
    var dark_opacity: Double
    var spin: Bool
    var saturate: Bool = false
    var material: Bool = true
    @State var isRotating = Double.random(in: 0..<360)
    var body: some View {
        ZStack {
            if material {
                Rectangle().fill(.primary.opacity(0.05))
                    .clipShape(Rectangle())
                    .overlay {
                        GeometryReader { g in
                            AlbumArtBGDisplay(ArtworkID: self.ArtworkID, Resolution: .background)
                                .blur(radius: blur, opaque: true)
                                .saturation(saturate ? 2 : 1.3)
                                .opacity(colorScheme == .dark ? dark_opacity : light_opacity)
                                .scaleEffect(1.4)
                                .rotationEffect(.degrees(isRotating))
                                .frame(width: g.size.width, height: g.size.height)
                                .contentShape(Rectangle())
                                .clipped()
                                .drawingGroup()
                                .onAppear {
                                    if spin {
                                        withAnimation(.linear(duration: 33)
                                            .repeatForever(autoreverses: false)) {
                                                isRotating = isRotating+360
                                            }
                                    }
                                }
                        }
                    }
                    .clipped()
                    .clipShape(Rectangle())

                
            } else {
                Rectangle().fill(Color.clear)
                    .overlay {
                        AlbumArtBGDisplay(ArtworkID: self.ArtworkID, Resolution: .blur)
                            .blur(radius: blur, opaque: true)
                            .saturation(saturate ? 2 : 1.3)
                            .opacity(colorScheme == .dark ? dark_opacity : light_opacity)
                            .scaleEffect(1.4)
                            .rotationEffect(.degrees(isRotating))
                            .allowsHitTesting(false)
                            .drawingGroup()
                            .onAppear {
                                if spin {
                                    withAnimation(.linear(duration: 33)
                                        .repeatForever(autoreverses: false)) {
                                            isRotating = isRotating+360
                                        }
                                }
                            }
                    }
                    .clipped()
            }
                    
                    
        }
            .allowsHitTesting(false)
            .ignoresSafeArea()
    }
}

#Preview {
    SearchAlbumContent(album: SearchedAlbum())
}

#Preview {
    SearchAlbumLink_classic(album: SearchedAlbum())
}

#Preview {
    VStack {
        temppicker()
            .pickerStyle(.segmented)
            .padding(.bottom, 30)
            .border(.red)
            .zIndex(2)
        testbutton()
            .border(.yellow)
//        VStack {
//            testbutton()
//            HStack {
//                testbutton()
//                testbutton()
//            }
//        }
    }
}





struct temppicker: View {
    @State var t: LibraryPicks = .recents
    var body: some View {
        Picker("Category", selection: $t) {
            ForEach(LibraryPicks.allCases) { option in
                Image(systemName: libraryPickSymbol(pick: option))
            }
        }
    }
}

struct testbutton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Spacer()
                VStack {
                    Text("hello there")
                }
                Spacer()
            }
            .padding(5)
            .background {
                AlbumBackground(ArtworkID: SearchedAlbum().Artwork, blur: 40, light_opacity: 1, dark_opacity: 1, spin: true, saturate: true)
                //AlbumBackground(ArtworkID: "", blur: 40, light_opacity: 1, dark_opacity: 1, spin: true, saturate: true)
            }
            //.clipped()
            
        }
        .buttonStyle(.plain)
    }
}
