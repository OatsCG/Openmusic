//
//  BasicAudioPlayer
//  String+Extensions.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

extension String {

    internal var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

}
