//
//  EQEditor.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import SwiftUI

struct EQEditor: View {
    @AppStorage("EQBand0") var EQBand0: Double = 0.5
    @AppStorage("EQBand1") var EQBand1: Double = 0.5
    @AppStorage("EQBand2") var EQBand2: Double = 0.5
    @AppStorage("EQBand3") var EQBand3: Double = 0.5
    @AppStorage("EQBand4") var EQBand4: Double = 0.5
    @AppStorage("EQBand5") var EQBand5: Double = 0.5
    @AppStorage("EQBand6") var EQBand6: Double = 0.5
    @AppStorage("EQBand7") var EQBand7: Double = 0.5
    //@AppStorage("EQBand8") var EQBand8: Double = 0.5
    //@AppStorage("EQBand9") var EQBand9: Double = 0.5
    
    var frameHeight: CGFloat = 300
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    Text("EQ modifications will only be applied to downloaded music. ")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    HStack {
                        VStack(alignment: .trailing) {
                            Text("12 dB")
                            Spacer()
                            Text("0")
                            Spacer()
                            Text("-12 dB")
                        }
                        .padding(.bottom, 20)
                        .frame(height: frameHeight)
                        .customFont(.callout)
                        VStack {
                            ZStack {
                                VStack {
                                    ForEach(0...4, id: \.self) {  _ in
                                        Spacer()
                                        Rectangle().fill(.primary.opacity(0.05)).frame(height: 2)
                                    }
                                    Spacer()
                                }
                                HStack {
                                    BandSlider(band: $EQBand0, index: 0)
                                    BandSlider(band: $EQBand1, index: 1)
                                    BandSlider(band: $EQBand2, index: 2)
                                    BandSlider(band: $EQBand3, index: 3)
                                    BandSlider(band: $EQBand4, index: 4)
                                    BandSlider(band: $EQBand5, index: 5)
                                    BandSlider(band: $EQBand6, index: 6)
                                    BandSlider(band: $EQBand7, index: 7)
                                    //BandSlider(band: $EQBand8, index: 8)
                                    //BandSlider(band: $EQBand9, index: 9)
                                }
                            }
                            .frame(height: frameHeight)
                            HStack {
                                // [32, 78, 189, 459, 1115, 2710, 6585, 16000]
                                //["32", "80", "190", "460", "1K", "3K", "6K", "16K"]
                                Text("32")
                                Spacer()
                                Text("80")
                                Spacer()
                                Text("190")
                                Spacer()
                                Text("460")
                                Spacer()
                                Text("1K")
                                Spacer()
                                Text("3K")
                                Spacer()
                                Text("6K")
                                Spacer()
                                Text("16K")
                            }
                            .customFont(.caption)
                        }
                    }
                    // saved presets
                    VStack {
                        
                    }
                }
            }
                .safeAreaPadding()
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

struct BandSlider: View {
    //@State var thisband: Double = 0
    @Environment(PlayerManager.self) var playerManager
    @Binding var band: Double
    var index: Int
    var body: some View {
        GeometryReader { geo in
            Slider(
                value: $band,
                in: 0...1,
                step: 0.02
            ).onChange(of: band) {
                playerManager.currentQueueItem?.audio_AVPlayer?.player.modifyEQ(index: index, value: band)
            }
            .rotationEffect(.degrees(-90.0), anchor: .topLeading)
            .frame(width: geo.size.height)
            .offset(y: geo.size.height)
            .tint(.blue)
        }
        //.border(.red)
    }
}

#Preview {
    EQEditor()
        .environment(PlayerManager())
        .environment(DownloadManager())
}
