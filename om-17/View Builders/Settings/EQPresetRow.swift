//
//  EQPresetRow.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-19.
//

import SwiftUI

struct EQPresetRow: View {
    @AppStorage("EQBandsCurrent") var EQBandsCurrent: String = ""
    @Binding var currentBands: [EQBand]
    @Binding var currentPresets: [EQPreset]
    @Binding var eqPreset: EQPreset
    @Binding var bandCount: Int
    @State var showingTitleCustomizer: Bool = false
    @State var customizedTitle: String = ""
    @State var customizingID: String = ""
    var body: some View {
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
                            if (band.index == 0) {
                                EQBandSlider(toModify: $band.value, title: condense_num(n: band.freq), canEdit: false)
                                    .clipShape(UnevenRoundedRectangle(
                                        topLeadingRadius: 2,
                                        bottomLeadingRadius: 2,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 0
                                    ))
                                    .padding(.trailing, 0)
                            } else if (band.index < 0) {
                                EQBandSlider(toModify: $band.value, title: condense_num(n: band.freq), canEdit: false)
                                    .clipShape(UnevenRoundedRectangle(
                                        topLeadingRadius: 0,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 2,
                                        topTrailingRadius: 2
                                    ))
                                    .padding(.trailing, 2)
                            } else {
                                EQBandSlider(toModify: $band.value, title: condense_num(n: band.freq), canEdit: false)
                                    .padding(.trailing, 0)
                            }
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

