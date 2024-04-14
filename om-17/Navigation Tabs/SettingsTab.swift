//
//  SettingsTab.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-04-12.
//

import SwiftUI

struct SettingsTab: View {
    var body: some View {
        SettingsPage()
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.thinMaterial, for: .tabBar)
    }
}
