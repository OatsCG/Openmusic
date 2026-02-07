//
//  ControlsOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-30.
//

import SwiftUI

struct ControlsOptions: View {
    @Environment(PlayerManager.self) var playerManager
    @AppStorage("volumeSkipEnabled") var volumeSkipEnabled: Bool = false
    @AppStorage("volumeSkipSpeed") var volumeSkipSpeed: Double = 0.3
    @AppStorage("volumeSkipMargin") var volumeSkipMargin: Double = 0.6
    @AppStorage("volumeSkipSelection") var volumeSkipSelection: Int = 1
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    Toggle("Skip via Volume Buttons", isOn: $volumeSkipEnabled)
                        .onChange(of: volumeSkipEnabled) { oldValue, newValue in
                            playerManager.volumeSkipEnabled = volumeSkipEnabled
                        }
                        .tint(.green)
                    HStack {
                        Text("Click Speed")
                        Picker("Volume Skip Speed", selection: $volumeSkipSelection) {
                            Text("Slow").tag(0)
                            Text("Medium").tag(1)
                            Text("Fast").tag(2)
                        }
                            .pickerStyle(.segmented)
                            .onChange(of: volumeSkipSelection) {
                                print("VOL: change")
                                print(volumeSkipSelection)
                                if volumeSkipSelection == 0 {
                                    volumeSkipSpeed = 1
                                    volumeSkipMargin = 1.2
                                } else if volumeSkipSelection == 1 {
                                    volumeSkipSpeed = 0.5
                                    volumeSkipMargin = 0.7
                                } else if volumeSkipSelection == 2 {
                                    volumeSkipSpeed = 0.2
                                    volumeSkipMargin = 0.4
                                }
                                playerManager.volumeSkipMargin = volumeSkipMargin
                                playerManager.volumeSkipSpeed = volumeSkipSpeed
                            }
                    }
                    .disabled(!volumeSkipEnabled)
                }, header: {
                    Text("Controls")
                }, footer: {
                    Text("Use your phone's volume buttons to skip songs in your pocket.\nVolume down-up: skip track\nVolume up-down: previous track")
                })
                
                Section {
                    NavigationLink(destination: ProximityEditor()) {
                        Text("Modify TrueDepth Range")
                    }
                } header: {
                    Text("Car Mode")
                } footer: {
                    Text("Control your music by waving your hand over the TrueDepth sensor. Activate Car Mode in the Fullscreen Mode of the \"Now Playing\" Sheet.")
                }
                
            }
                .scrollContentBackground(.hidden)
                .navigationTitle("Custom Controls")
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

#Preview {
    ControlsOptions()
        .environment(PlayerManager())
}
