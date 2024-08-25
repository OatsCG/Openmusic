//
//  VolumeObserver.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-30.
//

import SwiftUI
import MediaPlayer

@Observable final class VolumeObserver: Sendable {
    @MainActor static let shared = VolumeObserver()
    @MainActor let volumeView: MPVolumeView = MPVolumeView()
    let slider: UISlider?
    var currentVolume: Float
    var volumeTimer: Timer?
    var oldValue: Float? = nil
    var newValue: Float? = nil
    var VolumeSkipObserver: ((Float?) -> Void)?
    
    @MainActor private init() {
        self.slider = self.volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        if (self.slider != nil) {
            self.currentVolume = self.slider!.value
            
            self.slider!.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            
        } else {
            self.currentVolume = 0
            self.volumeTimer = nil
        }
    }
    
    @MainActor @objc private func sliderValueChanged(_ sender: UISlider) {
        if (self.slider?.value != self.currentVolume) {
            if (self.slider != nil) {
                self.oldValue = self.currentVolume
                self.newValue = self.slider!.value
                DispatchQueue.main.async {
                    withAnimation(.interactiveSpring) {
                        self.currentVolume = self.slider!.value
                    }
                    self.VolumeSkipObserver?(self.newValue)
                }
            }
        }
    }
    
//    func getVolume() -> Float {
//        return self.currentVolume
//    }
    
    func setVolume(_ volume: Float) {
        DispatchQueue.main.async {
            self.slider?.value = volume
            if (self.slider != nil) {
                self.sliderValueChanged(self.slider!)
            }
        }
    }
}
