//
//  CurrentTheme.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-22.
//

import SwiftUI

enum Theme: String, Identifiable, CaseIterable {
    case classic, honeycrisp, wii, spotty, faero, feco
    var id: Self { self }
}

enum Appearance: String, Identifiable, CaseIterable {
    case auto, light, dark
    var id: Self { self }
}

func availableAppearances(theme: Theme) -> [Appearance] {
    switch theme {
    case .classic:
        return [.auto, .light, .dark]
    case .honeycrisp:
        return [.auto, .light, .dark]
    case .wii:
        return [.auto, .light, .dark]
    case .spotty:
        return [.dark]
    case .faero:
        return [.auto, .light, .dark]
    case .feco:
        return [.auto, .light, .dark]
    }
}

func themeName(theme: Theme) -> String {
    switch theme {
    case .classic:
        return "Classic"
    case .honeycrisp:
        return "Honeycrisp"
    case .wii:
        return "Wii"
    case .spotty:
        return "Spotty"
    case .faero:
        return "Frutiger Aero"
    case .feco:
        return "Frutiger Eco"
    }
}

func themeName(theme: String) -> String {
    switch theme {
    case "classic":
        return "Classic"
    case "honeycrisp":
        return "Honeycrisp"
    case "wii":
        return "Wii"
    case "spotty":
        return "Spotty"
    case "faero":
        return "Frutiger Aero"
    case "feco":
        return "Frutiger Eco"
    default:
        return "None"
    }
}

func activeAppearance(theme: String, appearance: Appearance?) -> ColorScheme? {
    let themeSchemes: [Appearance] = availableAppearances(theme: Theme(rawValue: theme) ?? .classic)
    if (appearance != nil) {
        if (themeSchemes.contains(appearance!) == false) {
            switch themeSchemes.first {
            case .auto:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
            case .none:
                return nil
            }
        }
    }
    switch appearance {
    case .auto:
        return nil
    case .light:
        return .light
    case .dark:
        return .dark
    case .none:
        return nil
    }
}
