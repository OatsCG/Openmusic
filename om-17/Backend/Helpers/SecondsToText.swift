//
//  SecondsToText.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation

func secondsToText(seconds: Int) -> String {
    let hours: Int = Int(seconds / 3600)
    let minutes: Int = Int((seconds - hours * 3600) / 60)
    let seconds: Int = Int(seconds - (hours * 3600) - (minutes * 60))
    if (hours > 0) {
        //return(String(hours) + ":" + String(minute) + ":" + String(second))
        return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    } else {
        return String(format: "%i:%02i", minutes, seconds)
    }
}
func secondsToText(seconds: Double) -> String {
    if (seconds.isFinite == false) {
        return "--:--"
    }
    let secondsRounded = Int(seconds)
    let hours: Int = Int(secondsRounded / 3600)
    let minutes: Int = Int((secondsRounded - hours * 3600) / 60)
    let seconds: Int = Int(secondsRounded - (hours * 3600) - (minutes * 60))
    if (hours > 0) {
        //return(String(hours) + ":" + String(minute) + ":" + String(second))
        return String(format: "%i:%02i:%02i", hours, minutes, seconds)
    } else {
        return String(format: "%i:%02i", minutes, seconds)
    }
}
