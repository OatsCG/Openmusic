//
//  QuickFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

func fetchQuickSearchResults(query: String, completion: @escaping @Sendable (Result<FetchedTracks, Error>) -> Void) {
    let url = "\(globalIPAddress())/quick?q=\(query)"
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
                let fetchedData = try decoder.decode(FetchedTracks.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable final class QuickSearchViewModel: Sendable {
    var fetchedTracks: FetchedTracks? = nil
    var lastSearch: String = ""
    var SearchInitialized: Bool = false
    var attenptingSearch: Bool = false
    
    func runSearch(query: String) {
        withAnimation(.interactiveSpring(duration: 0.3)) {
            self.SearchInitialized = true
            self.attenptingSearch = true
            //self.searchResults = nil
            self.lastSearch = query
        }
        fetchQuickSearchResults(query: query) { (result) in
            switch result {
            case .success(let data):
                //main.async
                withAnimation(.interactiveSpring(duration: 0.3)) {
                    self.fetchedTracks = data
                    self.attenptingSearch = false
                }
            case .failure(let error):
                print("Error: \(error)")
                withAnimation(.interactiveSpring(duration: 0.3)) {
                    self.fetchedTracks = nil
                    self.attenptingSearch = false
                }
            }
        }
    }
    func runLastSearch() {
        self.runSearch(query: self.lastSearch)
    }
}
