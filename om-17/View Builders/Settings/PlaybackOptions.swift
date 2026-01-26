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
    @AppStorage("streamBitrateEnabled") var streamBitrateEnabled: Bool = false
    @AppStorage("streamBitrateCellular") var streamBitrateCellular: Double = 320
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
                    Text("Crossfade")
                } footer: {
                    Text("Choose to crossfade tracks that are consecutive in an album.")
                }
                
                Section("Play/Pause Fade") {
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
                    Toggle("Limit Bitrate on Cellular", isOn: $streamBitrateEnabled)
                        .tint(.green)
                    Slider(value: $streamBitrateCellular, in: 64...320, step: 32) {
                        Text("Stream Quality on Cellular")
                    } minimumValueLabel: {
                        Text("\(Int(streamBitrateCellular))kbps")
                    } maximumValueLabel: {
                        Text("")
                    } onEditingChanged: { _ in
                        
                    }
                    .disabled(!streamBitrateEnabled)
                } header: {
                    Text("Stream Quality")
                } footer: {
                    Text("Limit the streaming bitrate while on cellular data. Only available on supported servers.")
                }
                
                Section {
                    Toggle("Enable EQ", isOn: $EQEnabled)
                        .onChange(of: EQEnabled) { oldValue, newValue in
                            Task {
                                playerManager.currentQueueItem?.audio_AVPlayer?.update_EQ(enabled: newValue)
                            }
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
