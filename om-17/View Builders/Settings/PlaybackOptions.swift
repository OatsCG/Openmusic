//
//  PlaybackOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-30.
//

import SwiftUI

struct PlaybackOptions: View {
    @Environment(PlayerManager.self) var playerManager
    @AppStorage("crossfadeSeconds") var crossfadeSeconds: Double = 0
    @AppStorage("crossfadeAlbums") var crossfadeAlbums: Bool = false
    @AppStorage("playerFadeSeconds") var playerFadeSeconds: Double = 0
    @AppStorage("EQEnabled") var EQEnabled: Bool = false
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Slider(value: $crossfadeSeconds, in: 0...10, step: 1) {
                        Text("Crossfade Seconds")
                    } minimumValueLabel: {
                        Text("\(Int(crossfadeSeconds))s")
                    } maximumValueLabel: {
                        Text("")
                    } onEditingChanged: { bool in
                        playerManager.crossfadeSeconds = crossfadeSeconds == 0 ? 0.2 : crossfadeSeconds
                    }
                    Toggle("Crossfade Consecutive Tracks", isOn: $crossfadeAlbums)
                        .onChange(of: crossfadeAlbums) { oldValue, newValue in
                            playerManager.crossfadeAlbums = crossfadeAlbums
                        }
                        .tint(.green)
                } header: {
                    Text("CROSSFADE")
                } footer: {
                    Text("Choose to crossfade tracks that are consecutive in an album.")
                }
                
                Section("PLAY/PAUSE FADE") {
                    Slider(value: $playerFadeSeconds, in: 0...0.5, step: 0.05) {
                        Text("Play/Pause Fade Seconds")
                    } minimumValueLabel: {
                        Text("\(playerFadeSeconds, specifier: "%.2f")s")
                    } maximumValueLabel: {
                        Text("")
                    } onEditingChanged: { _ in
                        
                    }
                }
                
                Section {
                    Toggle("Enable EQ", isOn: $EQEnabled)
                        .onChange(of: EQEnabled) { oldValue, newValue in
                            playerManager.currentQueueItem?.audio_AVPlayer?.update_EQ(enabled: newValue)
                        }
                        .tint(.green)
                    NavigationLink(destination: EQEditor()) {
                        Text("Adjust Bands")
                    }
                } header: {
                    Text("Equalizer")
                } footer: {
                    Text("Equalizer adjustments are only available on downloaded music.")
                }
                
                
            }
                .scrollContentBackground(.hidden)
                .navigationTitle("Playback")
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

#Preview {
    PlaybackOptions()
        .environment(PlayerManager())
}
