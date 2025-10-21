//
//  ProximityEditor.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-09.
//

import SwiftUI

struct ProximityEditor: View {
    @AppStorage("proximityHorizontalColumn") var proximityHorizontalColumn: Double = 0.5
    @AppStorage("proximityVerticalRange") var proximityVerticalRange: Double = 1
    var rowCount: Int = 6
    
    var body: some View {
        ScrollView {
            Group {
                VStack {
                    Text("Customize the column and range of the TrueDepth sensor for Car Mode.")
                        .multilineTextAlignment(.center)
                    HStack {
                        ZStack {
                            VStack {
                                ProxColumnSlider(proximityHorizontalColumn: $proximityHorizontalColumn)
                                Spacer()
                            }
                            .frame(height: 500)
                            Image(.iphone)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 500)
                                .mask {
                                    Rectangle().fill(.linearGradient(colors: [.black, .clear], startPoint: .init(x: 0, y: 0.2), endPoint: .init(x: 0, y: 0.3)))
                                }
                                .offset(y: 230)
                            
                            // dots
                            DotVisualizer(proximityHorizontalColumn: $proximityHorizontalColumn, proximityVerticalRange: $proximityVerticalRange, rowCount: rowCount)
                        }
                        DoubleSlider(proximityVerticalRange: $proximityVerticalRange)
                    }
                    NPProximityTester()
                }
                    .safeAreaPadding(.all)
            }
        }
        
        .background {
            GlobalBackground_component()
                .ignoresSafeArea()
        }
    }
}

struct NPProximityTester: View {
    @AppStorage("proximityHorizontalColumn") var proximityHorizontalColumn: Double = 0.5
    @AppStorage("proximityVerticalRange") var proximityVerticalRange: Double = 1
    var proximityManager: ProximityManager = ProximityManager()
    let capturetimer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @State var captureGood: Bool = false
    @State var captureDepth: Float = 0
    
    var body: some View {
        VStack {
            Text("Test TrueDepth by hovering your hand")
                .foregroundStyle(.secondary)
            ZStack {
                RoundedRectangle(cornerRadius: 15.0).fill(Color(hue: 0.38, saturation: 1, brightness: Double(captureDepth))).stroke(.primary, lineWidth: 2)
                    .frame(width: 200, height: 40)
                if captureGood {
                    Image(systemName: "checkmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .black.opacity(0.7))
                        .font(.title)
                }
            }
        }
        .onReceive(capturetimer) { time in
            proximityManager.extractCenterPixel(row: Float(proximityHorizontalColumn), range: proximityVerticalRange, completion: { centerDepth in
                if let centerDepth {
                    captureGood = centerDepth.good
                    captureDepth = centerDepth.depth
                }
            })
        }
        .onDisappear {
            proximityManager.stopRunning()
        }
    }
}

struct DotVisualizer: View {
    @Binding var proximityHorizontalColumn: Double
    @Binding var proximityVerticalRange: Double
    var rowCount: Int
    
    var body: some View {
        Group {
            // top
            ForEach((0...Int(rowCount - 1)), id: \.self) { row in
                let columnNormal: CGFloat = CGFloat(row) / CGFloat(rowCount)
                let circleSize: CGFloat = 10 + CGFloat(row * 2)
                let normalColumn: CGFloat = CGFloat(proximityHorizontalColumn) * 2 - 1
                let sizedColumn: CGFloat = normalColumn * 80
                let offsetX: CGFloat = sizedColumn * columnNormal
                let offsetY: CGFloat = -CGFloat(row) * 40 * CGFloat(proximityVerticalRange)
                Circle().fill(.blue)
                    .frame(width: circleSize, height: circleSize)
                    .offset(x: offsetX, y: offsetY)
                    .opacity(1 - columnNormal)
            }
            // mid-top
            ForEach((0...Int(rowCount - 1)), id: \.self) { row in
                let columnNormal: CGFloat = CGFloat(row) / CGFloat(rowCount)
                let circleSize: CGFloat = 10 + CGFloat(row * 2)
                let normalColumn: CGFloat = CGFloat(proximityHorizontalColumn) * 2 - 1
                let sizedColumn: CGFloat = normalColumn * 80
                let offsetX: CGFloat = sizedColumn * columnNormal
                let scaledX: CGFloat = offsetX * 1.15
                let offsetY: CGFloat = -CGFloat(row) * 20 * CGFloat(proximityVerticalRange)
                Circle().fill(.blue)
                    .frame(width: circleSize, height: circleSize)
                    .offset(x: scaledX, y: offsetY)
                    .opacity(1 - columnNormal)
            }
            // middle
            ForEach((0...Int(rowCount - 1)), id: \.self) { row in
                let columnNormal: CGFloat = CGFloat(row) / CGFloat(rowCount)
                let circleSize: CGFloat = 10 + CGFloat(row * 2)
                let normalColumn: CGFloat = CGFloat(proximityHorizontalColumn) * 2 - 1
                let sizedColumn: CGFloat = normalColumn * 80
                let offsetX: CGFloat = sizedColumn * columnNormal
                let scaledX: CGFloat = offsetX * 1.3
                Circle().fill(.blue)
                    .frame(width: circleSize, height: circleSize)
                    .offset(x: scaledX, y: 0)
                    .opacity(1 - columnNormal)
            }
            // mid-bottom
            ForEach((0...Int(rowCount - 1)), id: \.self) { row in
                let columnNormal: CGFloat = CGFloat(row) / CGFloat(rowCount)
                let circleSize: CGFloat = 10 + CGFloat(row * 2)
                let normalColumn: CGFloat = CGFloat(proximityHorizontalColumn) * 2 - 1
                let sizedColumn: CGFloat = normalColumn * 80
                let offsetX: CGFloat = sizedColumn * columnNormal
                let scaledX: CGFloat = offsetX * 1.15
                let offsetY: CGFloat = CGFloat(row) * 20 * CGFloat(proximityVerticalRange)
                Circle().fill(.blue)
                    .frame(width: circleSize, height: circleSize)
                    .offset(x: scaledX, y: offsetY)
                    .opacity(1 - columnNormal)
            }
            // bottom
            ForEach((0...Int(rowCount - 1)), id: \.self) { row in
                let columnNormal: CGFloat = CGFloat(row) / CGFloat(rowCount)
                let circleSize: CGFloat = 10 + CGFloat(row * 2)
                let normalColumn: CGFloat = CGFloat(proximityHorizontalColumn) * 2 - 1
                let sizedColumn: CGFloat = normalColumn * 80
                let offsetX: CGFloat = sizedColumn * columnNormal
                let offsetY: CGFloat = CGFloat(row) * 40 * CGFloat(proximityVerticalRange)
                Circle().fill(.blue)
                    .frame(width: circleSize, height: circleSize)
                    .offset(x: offsetX, y: offsetY)
                    .opacity(1 - columnNormal)
            }
        }
    }
}

struct ProxColumnSlider: View {
    @Binding var proximityHorizontalColumn: Double
    
    var body: some View {
        Slider(
            value: $proximityHorizontalColumn,
            in: (0.01)...1,
            step: 0.01
        )
        .safeAreaPadding(.horizontal)
    }
}

struct DoubleSlider: View {
    @Binding var proximityVerticalRange: Double
    
    var body: some View {
        VStack {
            Slider(
                value: $proximityVerticalRange,
                in: (0.01)...1,
                step: 0.01
            )
            .frame(width: 250)
            .rotationEffect(.degrees(-90.0), anchor: .center)
            .contentShape(.rect)
        }
        .frame(width: 36, height: 250)
        .offset(y: -125)
    }
}

#Preview {
    ProximityEditor()
}
