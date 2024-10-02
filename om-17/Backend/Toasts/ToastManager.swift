//
//  ToastManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-21.
//

import SwiftUI

@Observable final class ToastManager: Sendable {
    static let shared = ToastManager()
    var toastHistory: [Toast] = []
    var currentToast: Toast? = nil
    var on: Bool = false
    
    func propose(toast: Toast) {
        DispatchQueue.main.async {
            var popTime: Double = 2
            switch toast.type {
            case .download:
                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UINotificationFeedbackGenerator().notificationOccurred(.success) }
                popTime = 3
            case .queuedOne:
                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
            case .queuedMany:
                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UINotificationFeedbackGenerator().notificationOccurred(.success) }
                popTime = 4
            case .saved:
                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UINotificationFeedbackGenerator().notificationOccurred(.success) }
            case .systemSuccess:
                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UINotificationFeedbackGenerator().notificationOccurred(.success) }
            case .systemError:
                if !UserDefaults.standard.bool(forKey: "AlertHapticsDisabled") { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
                popTime = 5
            case .systemNeutral:
                break
            }
            if self.on {
                self.crunch()
                Timer.scheduledTimer(withTimeInterval: 0.08, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.toastHistory.append(toast)
                        self.currentToast = toast
                        self.on = true
                    }
                }
                Timer.scheduledTimer(withTimeInterval: popTime + 0.08, repeats: false) { _ in
                    self.crunch(toast)
                }
            } else {
                self.crunch()
                Timer.scheduledTimer(withTimeInterval: 0.08, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.toastHistory.append(toast)
                        self.currentToast = toast
                        self.on = true
                    }
                }
                Timer.scheduledTimer(withTimeInterval: popTime + 0.08, repeats: false) { _ in
                    self.crunch(toast)
                }
            }
        }
    }
    
    func crunch(_ toast: Toast? = nil) {
        DispatchQueue.main.async {
            if toast == nil || toast == self.currentToast {
                withAnimation(.easeOut(duration: 0.2)) {
                    self.on = false
                    self.currentToast = nil
                }
            }
        }
    }
    
//    func on() -> Bool {
//        return self.currentToast != nil
//    }
}

final class Toast: Equatable, Sendable {
    let id: UUID = UUID()
    let artworkID: String
    let message: String
    let timeProposed: Date
    let type: ToastType
    let isSuggestion: Bool
    
    init(artworkID: String?, message: String, _ type: ToastType, wasSuggested: Bool = false) {
        self.artworkID = artworkID ?? ""
        self.message = message
        self.timeProposed = Date()
        self.type = type
        self.isSuggestion = wasSuggested
    }
    static func queuenext(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Queued Next", .queuedOne)
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Queued Next", .queuedMany)
        }
    }
    static func queuelater(_ artworkID: String?, count: Int = 1, wasSuggested: Bool = false) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Song Added to Queue", .queuedOne, wasSuggested: wasSuggested)
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Queued", .queuedMany, wasSuggested: wasSuggested)
        }
    }
    static func queuerandom(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Queued Randomly", .queuedOne)
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Queued Randomly", .queuedMany)
        }
    }
    static func library(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Added to Library", .saved)
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Added to Library", .saved)
        }
    }
    static func download(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Downloading Song", .download)
        } else {
            return Toast(artworkID: artworkID, message: "Downloading \(count) Songs", .download)
        }
    }
    static func playlist(_ artworkID: String?, playlist: Playlist, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Added to \"\(playlist.Title)\"", .saved)
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Added to \"\(playlist.Title)\"", .saved)
        }
    }
    static func copylink(_ artworkID: String?) -> Toast {
        return Toast(artworkID: artworkID, message: "Link Copied to Clipboard", .systemSuccess)
    }
    static func copylinkfailed() -> Toast {
        return Toast(artworkID: "", message: "Failed to Copy Link", .systemError)
    }
    static func linkopened() -> Toast {
        return Toast(artworkID: "", message: "Album Opened from Link", .systemNeutral)
    }
    static func linkopenfailed() -> Toast {
        return Toast(artworkID: "", message: "Failed to Open Link", .systemError)
    }
    static func likedSong(_ artworkID: String?) -> Toast {
        return Toast(artworkID: artworkID, message: "Added to Loved", .saved)
    }
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ToastType {
    case queuedOne, queuedMany, saved, download, systemSuccess, systemError, systemNeutral
    var id: Self { self }
}


#Preview {
    VStack {
        Spacer()
        MiniToasts()
        Button(action: {
            ToastManager.shared.propose(toast: Toast.library(""))
        }) {
            Text("update toast current")
        }
    }
}
