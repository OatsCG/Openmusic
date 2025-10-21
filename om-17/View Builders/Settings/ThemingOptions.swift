//
//  ThemingOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-30.
//

import SwiftUI

struct ThemingOptions: View {
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("currentTheme") var currentTheme: String = "classic"
    @AppStorage("preferredAppearance") var preferredAppearance: String = "auto"
    @AppStorage("customFonts") var customFonts: Bool = false
    @AppStorage("themeAnimations") var themeAnimations: Bool = false
    @AppStorage("artworkVideoAnimations") var artworkVideoAnimations: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink(destination: ThemeSelection()) {
                        VStack(alignment: .leading) {
                            Text("Select Theme")
                            Text(themeName(theme: currentTheme))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Toggle("Custom Fonts", isOn: $customFonts)
                        .tint(.green)
                    Toggle("Animations", isOn: $themeAnimations)
                        .tint(.green)
                    Toggle("Album Motion Artwork", isOn: $artworkVideoAnimations)
                        .tint(.green)
                } header: {
                    Text("THEMING")
                } footer: {
                    Text("Some options may require relaunching.")
                }
            }
                .scrollContentBackground(.hidden)
                .navigationTitle("Themes")
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

#Preview {
    ThemingOptions()
}
