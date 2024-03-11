//
//  downloadArtistBanner.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-19.
//

import SwiftUI

func BuildArtistBannerURL(imgID: String?, resolution: Resolution, aspectRatio: Double) -> URL? {
    if imgID == nil {
        return nil
//        let url = URL(string: "")
//        return url ?? nil
    } else {
        //let url = URL(string: "https://lh3.googleusercontent.com/\(imgID!)=w\(Int(size * aspectRatio))-h\(Int(size))-p-l90-rj")
        let url = URL(string: "https://lh3.googleusercontent.com/\(imgID!)")
        //let url = URL(string: "https://lh3.googleusercontent.com/\(imgID!)=w1080-h2160-p-l90-rj")
        return url ?? nil
    }
}

func downloadArtistBanner(ArtworkID: String, aspectRatio: Double) async {
    let downloadURL: String = "https://lh3.googleusercontent.com/\(ArtworkID)=w\(1080 * aspectRatio)-h\(1080)-l90-rj"
    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Banner-\(ArtworkID).jpg")
    if let destinationURL = destinationURL {
        if FileManager().fileExists(atPath: destinationURL.path) {
        } else {
            let urlRequest = URLRequest(url: URL(string: downloadURL)!)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    return
                }
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    //main.async
                    do {
                        try data.write(to: destinationURL, options: Data.WritingOptions.atomic)
                    } catch _ {
                        return
                    }
                }
            }
            dataTask.resume()
        }
    }
}

func ArtistBannerExists(ArtworkID: String) -> Bool {
    let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Banner-\(ArtworkID).jpg")
    if FileManager().fileExists(atPath: destination!.path) {
        return(true)
    }
    return(false)
}

func RetrieveArtistBanner(ArtworkID: String) -> URL {
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent("Banner-\(ArtworkID).jpg")
    return(destinationUrl!)
}
