//
//  ExploreFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-19.
//

import Foundation
import SwiftUI

func fetchExploreResults(completion: @escaping (Result<ExploreResults, Error>) -> Void) {
    let url = "\(globalIPAddress())/explore"
    guard let url = URL(string: url) else {
        print("Invalid URL.")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            let decoder = JSONDecoder()
            do {
                let fetchedData = try decoder.decode(ExploreResults.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable class ExploreViewModel {
    var exploreResults: ExploreResults? = nil
    var isSearching: Bool = false
    func runSearch() {
        if (self.isSearching) {
            return
        }
        withAnimation {
            self.isSearching = true
            self.exploreResults = nil
        }
        fetchExploreResults() { (result) in
            switch result {
            case .success(let data):
                withAnimation {
                    self.isSearching = false
                    self.exploreResults = data
                }
            case .failure(let error):
                withAnimation {
                    self.isSearching = false
                }
                print("Error: \(error)")
            }
        }
    }
}


struct ExploreResults: Codable, Hashable {
    var Shelves: [ExploreShelf]
    
    private enum CodingKeys: String, CodingKey {
        case Shelves
    }
}

struct ExploreShelf: Codable, Hashable {
    var Title: String
    var Albums: [SearchedAlbum]
    
    private enum CodingKeys: String, CodingKey {
        case Title, Albums
    }
}
