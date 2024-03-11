//
//  Networking.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation
import SwiftUI

func fetchSearchResults(query: String, completion: @escaping (Result<SearchResults, Error>) -> Void) {
    let url = "\(globalIPAddress())/search?q=\(query)"
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
                let fetchedData = try decoder.decode(SearchResults.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    task.resume()
}

@Observable class SearchViewModel {
    var searchResults: SearchResults? = nil
    var lastSearch: String = ""
    var SearchInitialized: Bool = false
    var attenptingSearch: Bool = false
    var fullSearchSubmitted: Bool = false
    var searchHasChanged: Bool = false
    
    func runSearch(query: String) {
        withAnimation {
            self.SearchInitialized = true
            self.attenptingSearch = true
            self.fullSearchSubmitted = true
            self.searchHasChanged = false
            self.lastSearch = query
        }
        fetchSearchResults(query: query) { (result) in
            switch result {
            case .success(let data):
                //main.async
                withAnimation {
                    self.searchResults = data
                    self.attenptingSearch = false
                }
            case .failure(let error):
                print("Error: \(error)")
                withAnimation {
                    self.searchResults = nil
                    self.attenptingSearch = false
                }
            }
        }
    }
    func runLastSearch() {
        self.runSearch(query: self.lastSearch)
    }
}
