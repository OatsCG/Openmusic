//
//  StreamRanger.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-05-02.
//

import Foundation

func bufferAudioData(from url: URL, startSeconds: Int, secondsToBuffer: Int, completionHandler: @escaping (Data?, Error?) -> Void) {
    // Assuming a bit rate of 128 kbps which translates to 16 KBps (kilobytes per second)
    let bytesPerSecond = 16000 // Adjust based on actual bit rate if known
    let startByte = startSeconds * bytesPerSecond
    let endByte = startByte + (secondsToBuffer * bytesPerSecond) - 1

    var request = URLRequest(url: url)
    request.addValue("bytes=\(startByte)-\(endByte)", forHTTPHeaderField: "Range")

    let session = URLSession(configuration: .default)
    let dataTask = session.dataTask(with: request) { data, response, error in
        if let error = error {
            completionHandler(nil, error)
        } else {
            completionHandler(data, nil)
        }
    }
    dataTask.resume()
}
