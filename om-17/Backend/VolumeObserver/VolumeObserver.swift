//
//  VolumeObserver.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-30.
//

import SwiftUI
import MediaPlayer

@Observable class VolumeObserver {
    static let shared = VolumeObserver()
    let volumeView: MPVolumeView = MPVolumeView()
    let slider: UISlider?
    var currentVolume: Float
    var volumeTimer: Timer?
    var oldValue: Float? = nil
    var newValue: Float? = nil
    var VolumeSkipObserver: ((Float?) -> Void)?
    
    private init() {
        self.slider = self.volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        if (self.slider != nil) {
            self.currentVolume = self.slider!.value
            
            self.slider!.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            
        } else {
            self.currentVolume = 0
            self.volumeTimer = nil
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        if (self.slider?.value != self.getVolume()) {
            if (self.slider != nil) {
                self.oldValue = self.getVolume()
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
    
    func getVolume() -> Float {
        return self.currentVolume
    }
    
    func setVolume(_ volume: Float) {
        DispatchQueue.main.async {
            self.slider?.value = volume
            if (self.slider != nil) {
                self.sliderValueChanged(self.slider!)
            }
        }
    }
}
