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
            updateLocalBands()
            updateStoredBands()
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
                                    .padding(.trailing, 0)
                            } else if (band.index < 0) {
                                EQBandSlider(toModify: $band.value, title: condense_num(n: band.freq), canEdit: false)
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
                    customizedTitle = eqPreset.name
                    customizingID = eqPreset.id
                    showingTitleCustomizer = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                }
                .alert("Edit EQ Preset Title", isPresented: $showingTitleCustomizer) {
                    TextField("Preset Name", text: $customizedTitle)
                        .autocorrectionDisabled()
                    Button(action: {
                        EQManager.editPresetTitle(presetID: customizingID, title: customizedTitle)
                        updateLocalPresets()
                        updateLocalBands()
                    }) {
                        Text("Save")
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
                
                Button(action: {
                    EQManager.deletePreset(preset: eqPreset)
                    updateLocalPresets()
                    updateLocalBands()
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
            currentBands = []
            currentBands = EQManager.decodeCurrentBands()
            bandCount = currentBands.count - 1
        }
    }
    
    private func updateLocalPresets() {
        withAnimation {
            currentPresets = EQManager.decodePresets()
        }
    }
    
    private func updateStoredBands() {
        EQManager.encodeBandsToCurrent(bands: currentBands)
    }
}
