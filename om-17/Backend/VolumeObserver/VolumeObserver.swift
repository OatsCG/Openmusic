//
//  VolumeObserver.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-12-30.
//

import SwiftUI
import MediaPlayer

@Observable final class VolumeObserver: Sendable {
//    static let shared = VolumeObserver()
    var volumeView: MPVolumeView?
    var slider: UISlider?
    var currentVolume: Float = 0
    var volumeTimer: Timer?
    var oldValue: Float? = nil
    var newValue: Float? = nil
    var VolumeSkipObserver: ((Float?) -> Void)?
    
    func initSliders() async {
        await volumeView = MPVolumeView()
        slider = await volumeView?.subviews.first(where: { $0 is UISlider }) as? UISlider
        if let slider {
            currentVolume = await slider.value
            await slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            
        } else {
            currentVolume = 0
            volumeTimer = nil
        }
    }
    
    @MainActor @objc private func sliderValueChanged(_ sender: UISlider) {
        if slider?.value != currentVolume {
            if let slider {
                oldValue = currentVolume
                newValue = slider.value
                withAnimation(.interactiveSpring) {
                    currentVolume = slider.value
                }
                VolumeSkipObserver?(newValue)
            }
        }
    }
    
//    func getVolume() -> Float {
//        return self.currentVolume
//    }
    
    @MainActor
    func setVolume(_ volume: Float) {
        slider?.value = volume
        if let slider {
            sliderValueChanged(slider)
        }
    }
}
