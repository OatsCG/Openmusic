//
//  ToastManager.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-21.
//

import SwiftUI

@Observable class ToastManager {
    static let shared = ToastManager()
    var toastHistory: [Toast] = []
    var currentToast: Toast? = nil
    var toastTimers: [Timer] = []
    var on: Bool = false
    
    func propose(toast: Toast) {
        //UIImpactFeedbackGenerator(style: .light).impactOccurred()
        DispatchQueue.main.async {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            if self.on {
                self.crunch()
                let t = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.toastHistory.append(toast)
                        self.currentToast = toast
                        self.on = true
                    }
                }
                self.toastTimers.append(t)
                let c = Timer.scheduledTimer(withTimeInterval: 2.08, repeats: false) { _ in
                    self.crunch(toast)
                }
                self.toastTimers.append(c)
            } else {
                self.crunch()
                withAnimation(.easeOut(duration: 0.2)) {
                    self.toastHistory.append(toast)
                    self.currentToast = toast
                    self.on = true
                }
                let c = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.crunch(toast)
                }
                self.toastTimers.append(c)
            }
        }
    }
    
    func crunch(_ toast: Toast? = nil) {
        DispatchQueue.main.async {
            if toast == nil || toast == self.currentToast {
                withAnimation(.easeOut(duration: 0.2)) {
                    self.currentToast = nil
                    self.on = false
                }
            }
        }
    }
    
//    func on() -> Bool {
//        return self.currentToast != nil
//    }
}

class Toast: Equatable {
    var id: UUID = UUID()
    var artworkID: String
    var message: String
    var timeProposed: Date
    init(artworkID: String?, message: String) {
        self.artworkID = artworkID ?? ""
        self.message = message
        self.timeProposed = Date()
    }
    static func queuenext(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Queued Next")
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Queued Next")
        }
    }
    static func queuelater(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Song Added to Queue")
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Queued")
        }
    }
    static func queuerandom(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Queued Randomly")
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Queued Randomly")
        }
    }
    static func library(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Added to Library")
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Added to Library")
        }
    }
    static func download(_ artworkID: String?, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Downloading Song")
        } else {
            return Toast(artworkID: artworkID, message: "Downloading \(count) Songs")
        }
    }
    static func playlist(_ artworkID: String?, playlist: Playlist, count: Int = 1) -> Toast {
        if count == 1 {
            return Toast(artworkID: artworkID, message: "Added to \"\(playlist.Title)\"")
        } else {
            return Toast(artworkID: artworkID, message: "\(count) Songs Added to \"\(playlist.Title)\"")
        }
    }
    static func copylink(_ artworkID: String?) -> Toast {
        return Toast(artworkID: artworkID, message: "Link Copied to Clipboard")
    }
    static func copylinkfailed() -> Toast {
        return Toast(artworkID: "", message: "Failed to Copy Link")
    }
    static func linkopened() -> Toast {
        return Toast(artworkID: "", message: "Album Opened from Link")
    }
    static func linkopenfailed() -> Toast {
        return Toast(artworkID: "", message: "Failed to Open Link")
    }
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        return lhs.id == rhs.id
    }
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
