//
//  StreamAssetGatherer.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-05-02.
//

import AVFoundation

/// Fetches the duration of an audio file from a URL.
/// - Parameters:
///   - url: The URL of the audio file.
///   - completion: The completion handler to call with the duration in seconds or an error.
func fetchAudioMetadata(from url: URL, completion: @escaping (Result<Double, Error>) -> Void) {
    let asset = AVURLAsset(url: url, options: nil)
    Task.detached {
        let metadata: [AVMetadataItem]? = try? await asset.load(.commonMetadata)
        if let metadata = metadata {
            print("METADATA:")
            print(metadata)
        } else {
            print("NO METADATA")
        }
    }
    
}
