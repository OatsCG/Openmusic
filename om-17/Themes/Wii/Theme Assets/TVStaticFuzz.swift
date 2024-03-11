//
//  TVStaticFuzz.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-14.
//

import SwiftUI

struct TVStaticFuzz: View {
    @State var noiserotation: Double = 0
    let noisetimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        Image(.whitenoise)
            .resizable()
            .scaledToFill()
            .opacity(0.04)
            .rotationEffect(Angle(degrees: noiserotation))
            .onReceive(noisetimer) { time in
                if (UserDefaults.standard.bool(forKey: "themeAnimations") == true) {
                    noiserotation += 90
                }
            }
    }
}

#Preview {
    TVStaticFuzz()
}
