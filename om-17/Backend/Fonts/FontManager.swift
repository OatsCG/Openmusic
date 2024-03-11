//
//  FontManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-01-01.
//

import SwiftUI

class FontManager {
    static let shared: FontManager = FontManager()
    
    static func currentThemeFontName(bold: Bool = false) -> String {
        switch UserDefaults.standard.string(forKey: "currentTheme") {
        case "classic":
            return ""
        case "honeycrisp":
            return ""
        case "wii":
            return bold ? "RodinPro-B" : "RodinNTLGPro-DB"
        case "spotty":
            return bold ? "CircularStd-Bold" : "CircularStd-Book"
        case "faero":
            return bold ? "Calibri-Bold" : "Calibri"
        case "feco":
            return bold ? "Calibri-Bold" : "Calibri"
        default:
            return ""
        }
    }
    
    static func currentThemeFont(font: Font, style: Font.TextStyle, bold: Bool) -> Font {
        if (UserDefaults.standard.bool(forKey: "customFonts") == false) {
            return Font.system(style, weight: bold ? .bold : .regular)
        }
        let fontName = currentThemeFontName(bold: bold)
        if (fontName == "") {
            return Font.system(style, weight: bold ? .bold : .regular)
        } else {
            return Font.custom(fontName, size: FontManager.customFontSize(font), relativeTo: style)
        }
    }
    
    static func forceCurrentThemeFont(font: Font, style: Font.TextStyle, bold: Bool, theme: Theme) -> Font {
        let fontName = theme.rawValue
        if (fontName == "") {
            return Font.system(style, weight: bold ? .bold : .regular)
        } else {
            return Font.custom(fontName, size: FontManager.customFontSize(font), relativeTo: style)
        }
    }
    
    static func currentThemeUIFont(_ font: Font, bold: Bool = false) -> UIFont {
        if (UserDefaults.standard.bool(forKey: "customFonts") == false) {
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: .systemFont(ofSize: customFontSize(font), weight: bold ? .bold : .regular))
        }
        switch UserDefaults.standard.string(forKey: "currentTheme") {
        case "classic":
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: .systemFont(ofSize: customFontSize(font), weight: bold ? .bold : .regular))
        case "honeycrisp":
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: .systemFont(ofSize: customFontSize(font), weight: bold ? .bold : .regular))
        case "wii":
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: UIFont(name: bold ? "RodinPro-B" : "RodinNTLGPro-DB", size: customFontSize(font))!)
        case "spotty":
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: UIFont(name: bold ? "CircularStd-Bold" : "CircularStd-Book", size: customFontSize(font))!)
        case "faero":
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: UIFont(name: bold ? "Calibri-Bold" : "Calibri", size: customFontSize(font))!)
        case "feco":
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: UIFont(name: bold ? "Calibri-Bold" : "Calibri", size: customFontSize(font))!)
        default:
            return UIFontMetrics(forTextStyle: fontToUIFont(font)).scaledFont(for: .systemFont(ofSize: customFontSize(font), weight: bold ? .bold : .regular))
        }
    }
    
    static func fontToUIFont(_ font: Font) -> UIFont.TextStyle {
        switch font {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption:
            return .caption1
        case .caption2:
            return .caption2
        default:
            return .body
        }
    }
    
    static func customFontSize(_ font: Font) -> CGFloat {
        switch font {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        default:
            return 14
        }
    }
    
    
}

extension View {
    func forceCustomFont(_ font: Font, bold: Bool = false, theme: Theme) -> some View {
        let shadowDepth: CGFloat = 0
        let shadowColor = Color.secondary.opacity(0)
        switch font {
        case .largeTitle:
            return self.font(FontManager.forceCurrentThemeFont(font: .largeTitle, style: .largeTitle, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .title:
            return self.font(FontManager.forceCurrentThemeFont(font: .title, style: .title, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .title2:
            return self.font(FontManager.forceCurrentThemeFont(font: .title2, style: .title2, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .title3:
            return self.font(FontManager.forceCurrentThemeFont(font: .title3, style: .title3, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .headline:
            return self.font(FontManager.forceCurrentThemeFont(font: .headline, style: .headline, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .body:
            return self.font(FontManager.forceCurrentThemeFont(font: .body, style: .body, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .callout:
            return self.font(FontManager.forceCurrentThemeFont(font: .callout, style: .callout, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .subheadline:
            return self.font(FontManager.forceCurrentThemeFont(font: .subheadline, style: .subheadline, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .footnote:
            return self.font(FontManager.forceCurrentThemeFont(font: .footnote, style: .footnote, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .caption:
            return self.font(FontManager.forceCurrentThemeFont(font: .caption, style: .caption, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .caption2:
            return self.font(FontManager.forceCurrentThemeFont(font: .caption2, style: .caption2, bold: bold, theme: theme))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        default:
            //return self.font(Font.custom(FontManager.currentThemeFont(bold: bold), size: 14, relativeTo: .body))
            return self.font(Font.system(.body, weight: bold ? .bold : .regular))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        }
    }
    
    func customFont(_ font: Font, bold: Bool = false) -> some View {
        let shadowDepth: CGFloat = 0
        let shadowColor = Color.secondary.opacity(0)
        switch font {
        case .largeTitle:
            return self.font(FontManager.currentThemeFont(font: .largeTitle, style: .largeTitle, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .title:
            return self.font(FontManager.currentThemeFont(font: .title, style: .title, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .title2:
            return self.font(FontManager.currentThemeFont(font: .title2, style: .title2, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .title3:
            return self.font(FontManager.currentThemeFont(font: .title3, style: .title3, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .headline:
            return self.font(FontManager.currentThemeFont(font: .headline, style: .headline, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .body:
            return self.font(FontManager.currentThemeFont(font: .body, style: .body, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .callout:
            return self.font(FontManager.currentThemeFont(font: .callout, style: .callout, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .subheadline:
            return self.font(FontManager.currentThemeFont(font: .subheadline, style: .subheadline, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .footnote:
            return self.font(FontManager.currentThemeFont(font: .footnote, style: .footnote, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .caption:
            return self.font(FontManager.currentThemeFont(font: .caption, style: .caption, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        case .caption2:
            return self.font(FontManager.currentThemeFont(font: .caption2, style: .caption2, bold: bold))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        default:
            //return self.font(Font.custom(FontManager.currentThemeFont(bold: bold), size: 14, relativeTo: .body))
            return self.font(Font.system(.body, weight: bold ? .bold : .regular))
                .shadow(color: shadowColor, radius: 0, x: 0, y: shadowDepth)
        }
    }
}



#Preview {
    @AppStorage("currentTheme") var currentTheme: String = "faero"
    return ScrollView {
        HStack(spacing: 40) {
            VStack {
                Text("largeTitle")
                    .font(.largeTitle)
                Text("title")
                    .font(.title)
                Text("title2")
                    .font(.title2)
                Text("title3")
                    .font(.title3)
                Text("title3.bold()")
                    .font(.title3 .bold())
                Text("headline")
                    .font(.headline)
                Text("body")
                    .font(.body).border(.blue)
                Text("callout")
                    .font(.callout).border(.blue)
                Text("subheadline")
                    .font(.subheadline).border(.blue)
                Text("footnote")
                    .font(.footnote).border(.blue)
                Text("caption")
                    .font(.caption).border(.blue)
                Text("caption2")
                    .font(.caption2).border(.blue)
            }
            .border(.red)
            VStack {
                Text("largeTitle")
                    .customFont(.largeTitle)
                Text("title")
                    .customFont(.title)
                Text("title2")
                    .customFont(.title2)
                Text("title3")
                    .customFont(.title3)
                Text("title3.bold()")
                    .customFont(.title3, bold: true)
                Text("headline")
                    .customFont(.headline)
                Text("body")
                    .customFont(.body)
                Text("callout")
                    .customFont(.callout)
                Text("subheadline")
                    .customFont(.subheadline)
                Text("footnote")
                    .customFont(.footnote)
                Text("caption")
                    .customFont(.caption)
                Text("caption2")
                    .customFont(.caption2)
            }
            .border(.red)
            .onAppear {
                currentTheme = "faero"
                for family in UIFont.familyNames.sorted() {
                    print("Family: \(family)")
                    let names = UIFont.fontNames(forFamilyName: family)
                    for fontName in names {
                        print("- \(fontName)")
                    }
                }
            }
        }
    }
}
