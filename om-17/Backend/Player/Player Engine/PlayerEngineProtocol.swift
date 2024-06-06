//
//  PlayerEngine.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-09-07.
//

import SwiftUI
import AVFoundation
import CoreAudio

protocol PlayerEngineProtocol: Equatable {
    var id: UUID {get set}
    var isReady: Bool {get set}
    var isSeeking: Bool {get set}
    var currentTime: Double {get}
    func duration() -> Double
    func volume() -> Float
    func set_volume(to: Float)
    func has_file() -> Bool
    func clear_file()
    func seek(to: Double)
    func seek_to_zero()
    func preroll(completion: @escaping (_ success: Bool) -> Void)
    func playImmediately()
    func play()
    func pause()
}

extension PlayerEngineProtocol {
    func isEqual(to other: (any PlayerEngineProtocol)?) -> Bool {
        return self.id == other?.id
    }
}
