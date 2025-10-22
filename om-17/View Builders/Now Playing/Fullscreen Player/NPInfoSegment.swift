//
//  NPInfoSegment.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-23.
//

import SwiftUI

struct NPInfoSegment: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Binding var showingNPSheet: Bool
    @Binding var fullscreen: Bool
    @Binding var carModeEnabled: Bool
    @Binding var passedNSPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 10) {
            NPTitles(showingNPSheet: $showingNPSheet, fullscreen: $fullscreen, passedNSPath: $passedNSPath)
                .padding(.top, 5)
            NPControls(fullscreen: $fullscreen, carModeEnabled: $carModeEnabled)
        }
    }
}
