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
//                    Picker(
//                        selection: $currentTheme,
//                        label: Text("Current theme")
//                    ) {
//                        ForEach(Theme.allCases, id: \.self) {
//                            switch $0 {
//                            case .classic:
//                                Text("Classic").tag($0.rawValue)
//                                    .tint(GlobalTint_component(currentTheme: $0.rawValue, colorScheme: colorScheme))
//                            case .honeycrisp:
//                                Text("Honeycrisp").tag($0.rawValue)
//                                    .tint(GlobalTint_component(currentTheme: $0.rawValue, colorScheme: colorScheme))
//                            case .wii:
//                                Text("Wii").tag($0.rawValue)
//                                    .tint(GlobalTint_component(currentTheme: $0.rawValue, colorScheme: colorScheme))
//                            case .spotty:
//                                Text("Spotty").tag($0.rawValue)
//                                    .tint(GlobalTint_component(currentTheme: $0.rawValue, colorScheme: colorScheme))
//                            case .faero:
//                                Text("Frutiger Aero").tag($0.rawValue)
//                                    .tint(GlobalTint_component(currentTheme: $0.rawValue, colorScheme: colorScheme))
//                            case .feco:
//                                Text("Frutiger Eco").tag($0.rawValue)
//                                    .tint(GlobalTint_component(currentTheme: $0.rawValue, colorScheme: colorScheme))
//                                
//                            }
//                        }
//                    }
//                    Picker("Appearance", selection: $preferredAppearance) {
//                        ForEach(Appearance.allCases, id: \.self) { option in
//                            if availableAppearances(theme: Theme(rawValue: currentTheme) ?? .classic).contains(option) {
//                                Text(option.rawValue.capitalized).tag(option.rawValue)
//                            }
//                        }
//                    }
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
