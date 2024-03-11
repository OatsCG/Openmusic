//
//  NPControls.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-18.
//

import SwiftUI

struct NPControls: View {
    @Binding var fullscreen: Bool
    @Binding var carModeEnabled: Bool
    var body: some View {
        VStack(spacing: 20) {
            NPTrackScrubber(fullscreen: $fullscreen)
            if !fullscreen {
                NPControlButtons()
                NPVolumeScrubber()
            }
        }
    }
}
