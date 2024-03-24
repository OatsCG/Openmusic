//
//  EQEditor.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI
import SwiftData

struct EQEditor: View {
    @Environment(PlayerManager.self) var playerManager
    @AppStorage("EQBandsCurrent") var EQBandsCurrent: String = ""
    @AppStorage("EQBandsPresets") var EQBandsPresets: String = ""
    @State var currentBands: [EQBand] = []
    @State var currentPresets: [EQPreset] = []
    @State var bandCount: Int = 8
    @State var customizedTitle: String = ""
    @State var customizingID: String = ""
    @State var showingTitleCustomizer: Bool = false
    var frameHeight: CGFloat = 300
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Text("EQ modifications will only be applied to downloaded music. ")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    HStack {
                        Button(action: {
                            EQManager.appendPreset()
                            updateLocalPresets()
                        }) {
                            AlbumWideButton_component(text: "Save Preset", ArtworkID: "")
                        }
                        Spacer()
                        Stepper(value: $bandCount, in: 5...12) {
                            HStack {
                                Spacer()
                                Text("\(bandCount) Bands")
                            }
                        }
                            .onChange(of: bandCount) {
                                self.currentBands = EQManager.decodeCurrentBands(count: self.bandCount + 1)
                                self.updateStoredBands()
                                self.playerManager.resetEQs()
                            }
                    }
                    HStack {
                        VStack(alignment: .trailing) {
                            Text("12 dB")
                            Spacer()
                            Text("0")
                            Spacer()
                            Text("-12 dB")
                        }
                            .customFont(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 20)
                            .padding(.trailing, 3)
                            .frame(height: frameHeight)
                        VStack {
                            ZStack {
                                VStack {
                                    ForEach(0...4, id: \.self) {  _ in
                                        Spacer()
                                        Rectangle().fill(.primary.opacity(0.05)).frame(height: 2)
                                    }
                                    Spacer()
                                }
                                HStack(spacing: 3) {
                                    VStack {
                                        if (currentBands.count > 1) {
                                            EQBandSlider(toModify: $currentBands.first!.value, title: "AMP")
                                                .onChange(of: currentBands.first?.value) {
                                                    updateStoredBands()
                                                    playerManager.currentQueueItem?.audio_AVPlayer?.player.modifyEQ(index: -1, value: Double(currentBands.first?.value ?? 0.5))
                                                }
                                                .customFont(.caption)
                                                .lineLimit(1)
                                        }
                                    }
                                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 12, bottomTrailingRadius: 5, topTrailingRadius: 5))
                                        .padding(.trailing, 4)
                                    ForEach($currentBands, id: \.index) { $band in
                                        if (band.index >= 0) {
                                            EQBandSlider(toModify: $band.value, title: condense_num(n: band.freq))
                                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: band.index == 0 ? 5 : 0, bottomLeadingRadius: band.index == 0 ? 5 : 0, bottomTrailingRadius: 0, topTrailingRadius: 0))
                                                .onChange(of: band.value) {
                                                    updateStoredBands()
                                                    playerManager.currentQueueItem?.audio_AVPlayer?.player.modifyEQ(index: band.index, value: band.value)
                                                }
                                        }
                                    }
                                }
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 12, topTrailingRadius: 12))
                            }
                            .frame(height: frameHeight)
                            HStack {
                                Text("AMP")
                                    .padding(.trailing, 3)
                                ForEach($currentBands, id: \.index) { $band in
                                    Spacer()
                                    Text(condense_num(n: band.freq))
                                }
                                Spacer()
                            }
                            .customFont(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        }
                    }
                    // saved presets
                    VStack {
                        HStack {
                            if currentPresets.count > 0 {
                                Text("Presets")
                                    .customFont(.title, bold: true)
                                    .padding(.top)
                                Spacer()
                            }
                        }
                        ForEach($currentPresets, id: \.id) { $eqPreset in
                            Button(action: {
                                EQBandsCurrent = EQManager.encodeBands(bands: eqPreset.bands)
                                self.updateLocalBands()
                                self.updateStoredBands()
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(eqPreset.name)
                                            if eqPreset.bands.elementsEqual(currentBands) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .symbolRenderingMode(.hierarchical)
                                            }
                                        }
                                        HStack(spacing: 2) {
                                            ForEach($eqPreset.bands, id: \.index) { $band in
                                                EQBandSlider(toModify: $band.value, title: condense_num(n: band.freq), canEdit: false)
                                                    .drawingGroup()
                                                    .clipShape(UnevenRoundedRectangle(
                                                        topLeadingRadius: band.index == 0 ? 2 : 0,
                                                        bottomLeadingRadius: band.index == 0 ? 2 : 0,
                                                        bottomTrailingRadius: band.index < 0 ? 2 : 0,
                                                        topTrailingRadius: band.index < 0 ? 2 : 0
                                                    ))
                                                    .padding(.trailing, band.index < 0 ? 2 : 0)
                                            }
                                        }
                                            .frame(height: 25)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                            .padding(.trailing, 100)
                                            .allowsHitTesting(false)
                                    }
                                    Spacer()
                                    Button(action: {
                                        self.customizedTitle = eqPreset.name
                                        self.customizingID = eqPreset.id
                                        self.showingTitleCustomizer = true
                                    }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .font(.title)
                                    }
                                    .alert("Edit EQ Preset Title", isPresented: $showingTitleCustomizer) {
                                        TextField("Preset Name", text: $customizedTitle)
                                            .autocorrectionDisabled()
                                        Button(action: {
                                            EQManager.editPresetTitle(presetID: self.customizingID, title: self.customizedTitle)
                                            self.updateLocalPresets()
                                            self.updateLocalBands()
                                        }) {
                                            Text("Save")
                                        }
                                        
                                        Button("Cancel", role: .cancel) { }
                                    }
                                    
                                    Button(action: {
                                        EQManager.deletePreset(preset: eqPreset)
                                        self.updateLocalPresets()
                                        self.updateLocalBands()
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .font(.title)
                                    }
                                }
                                .padding(10)
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .safeAreaPadding()
            }
                .background {
                    GlobalBackground_component()
                }
        }
        .task {
            updateLocalBands()
            updateLocalPresets()
        }
    }
    private func updateLocalBands() {
        withAnimation {
            self.currentBands = []
            self.currentBands = EQManager.decodeCurrentBands()
            self.bandCount = self.currentBands.count - 1
        }
    }
    private func updateLocalPresets() {
        withAnimation {
            self.currentPresets = EQManager.decodePresets()
        }
    }
    
    private func updateStoredBands() {
        EQManager.encodeBandsToCurrent(bands: self.currentBands)
    }
}

func printBands(bands: [EQBand]) {
    var strarr: [String] = []
    for i in bands {
        strarr.append(String(i.value))
    }
    print(strarr.joined(separator: ", "))
}

#Preview {
    EQEditor()
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .environment(OMUser())
}

#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self, configurations: config)

    let playlist = StoredPlaylist(Title: "Test!")
    container.mainContext.insert(playlist)
    
    return ContentView()
        .modelContainer(container)
        .environment(PlayerManager())
        .environment(PlaylistImporter())
        .environment(DownloadManager())
        .environment(NetworkMonitor())
        .environment(OMUser())
        .task {
            currentTheme = "classic"
            globalIPAddress = "https://server.openmusic.app"
        }
}
