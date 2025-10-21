//
//  OnboardSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-29.
//

import SwiftUI

struct OnboardSheet: View {
    @Binding var onboard: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            VStack {
                Text("Welcome to Openmusic")
                    .font(.largeTitle .bold())
            }
            .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.tint)
                        .imageScale(.medium)
                        .font(.largeTitle)
                        .frame(width: 60)
                    Text("Save music to your library, and **Download \(Image(systemName: "square.and.arrow.down"))** to listen offline")
                        .font(.body)
                    Spacer()
                }
                HStack {
                    Image(systemName: "music.note.list")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.tint)
                        .imageScale(.medium)
                        .font(.largeTitle)
                        .frame(width: 60)
                    Text("Create playlists, or **Import \(Image(systemName: "arrow.down.to.line"))** a link from other platforms")
                        .font(.body)
                    Spacer()
                }
                HStack {
                    Image(systemName: "iphone.gen2.landscape")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(AngularGradient(colors: [
                            .red,
                            .orange,
                            .yellow,
                            .green,
                            .blue,
                            .indigo,
                            .purple,
                            .red
                        ], center: UnitPoint(x: 0.5, y: 0.5), angle: .degrees(0)))
                        .imageScale(.medium)
                        .font(.largeTitle)
                        .frame(width: 60)
                    Text("Experience your music in landscape with **Fullscreen Mode \(Image(systemName: "arrow.up.left.and.arrow.down.right"))**")
                        .font(.body)
                    Spacer()
                }
                HStack {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.green, .wiiprimary)
                        .imageScale(.medium)
                        .font(.largeTitle)
                        .frame(width: 60)
                    Text("Choose a theme that suits you in **Options \(Image(systemName: "gear"))**")
                        .font(.body)
                    Spacer()
                }
                HStack {
                    Image(systemName: "button.vertical.left.press.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.primary)
                        .imageScale(.medium)
                        .font(.largeTitle)
                        .frame(width: 60)
                    Text("Skip songs with the volume buttons, or by waving your hand. Enable gestures in **Options \(Image(systemName: "gear"))**")
                        .font(.body)
                    Spacer()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Button(action: { onboard = false }) {
                HStack {
                    Spacer()
                    VStack {
                        Text("Get Started")
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                    .font(.body .bold())
                    .padding(10)
                    .background(.tint)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .contentShape(Rectangle())
                    .frame(width: 250)
            }
            .buttonStyle(.plain)
            
        }
        .safeAreaPadding(.all)
        .lineLimit(5)
    }
}

#Preview {
    @Previewable @State var pres: Bool = true
    
    return Text("hi!")
        .sheet(isPresented: $pres) {
            OnboardSheet(onboard: $pres)
        }
        .environment(PlayerManager())
        .environment(NetworkMonitor())
        .environment(FontManager())
}
