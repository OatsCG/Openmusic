//
//  NPProximityWarning.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-12.
//

import SwiftUI

struct NPProximityWarning: View {
    @Environment(FontManager.self) private var fontManager
    @State var showing: Bool = true
    var body: some View {
        if showing {
            Text("Wave to skip, hover to pause/play.\n Car Mode is energy excessive.")
                .customFont(fontManager, .caption)
                .multilineTextAlignment(.center)
                .onAppear {
                    _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                        withAnimation {
                            DispatchQueue.main.async {
                                self.showing = false
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    NPProximityWarning()
}
