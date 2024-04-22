//
//  MiniToasts.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-21.
//

import SwiftUI

struct MiniToasts: View {
    @Environment(FontManager.self) private var fontManager
    @State var toastManager: ToastManager = ToastManager.shared
    var body: some View {
        HStack {
            AlbumArtDisplay(ArtworkID: toastManager.on ? (toastManager.currentToast?.artworkID ?? "") : "", Resolution: .cookie, Blur: 0, BlurOpacity: 0, cornerRadius: 6)
                .frame(width: 30, height: 30)
            if (ToastManager.shared.currentToast?.isSuggestion == true) {
                Text(toastManager.on ? toastManager.currentToast!.message : "")
                    .customFont(fontManager, .subheadline, bold: true)
                QSQueueRowSparkle()
            } else {
                Text(toastManager.on ? (toastManager.currentToast?.message ?? "") : "")
                    .customFont(fontManager, .subheadline, bold: true)
                    .padding([.trailing], 16)
            }
        }
            .multilineTextAlignment(.center)
            .padding([.top, .leading], 7)
            .padding([.bottom], toastManager.on ? 8 : -100)
            .opacity(toastManager.on ? 1 : 0)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                toastManager.crunch()
            }
    }
}

#Preview {
    VStack {
        Spacer()
        MiniToasts()
        Button(action: {
            ToastManager.shared.propose(toast: Toast.download(""))
        }) {
            Text("update toast current")
        }
    }
}
