//
//  EQBandSlider.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-19.
//

import SwiftUI

struct EQBandSlider: View {
    @Binding var toModify: Double
    var title: String
    var canEdit: Bool = true
    @State var isSliding: Bool = false
    @State var initialValue: Double = 0
    var stepCount: Int = 36 // 6 sections * 6
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle().fill(.primary).opacity(0.2)
                    Rectangle().fill(.primary).opacity(isSliding ? 0.9 : 0.6)
                        .scaleEffect(x: 1, y: CGFloat(toModify), anchor: .bottom)
                }
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        guard canEdit else { return }
                        if !isSliding {
                            withAnimation {
                                isSliding = true
                            }
                            initialValue = toModify
                        }
                        let normalizedValue: CGFloat = -value.translation.height / geo.size.height
                        let toPush: Double = normalizedValue + Double(initialValue)
                        let steppedPush: Double = ceil(toPush * Double(stepCount) - 0.5) / CGFloat(stepCount)
                        let clampedPush: Double = min(max(steppedPush, 0), 1)
                        
                        withAnimation(.default.speed(2.5)) {
                            toModify = Double(clampedPush)
                        }
                    }
                    .onEnded { value in
                        if canEdit {
                            withAnimation {
                                isSliding = false
                            }
                        }
                        
                    }
                )
            }
        }
    }
}

struct eqprev: View {
    @State var toModify: Double = 0.75
    
    var body: some View {
        EQBandSlider(toModify: $toModify, title: "")
            .frame(width: 50, height: 200)
    }
}

#Preview {
    eqprev()
}
