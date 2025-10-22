//
//  Networking.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation
import SwiftUI

// Function to fetch search results
func fetchSearchResults(query: String) async throws -> SearchResults {
    try await NetworkManager.shared.fetch(endpoint: .search(q: query), type: SearchResults.self)
}

// Actor to manage search data
actor SearchViewActor {
    private var searchResults: SearchResults? = nil
    private var lastSearch: String = ""
    private var searchInitialized: Bool = false
    private var attemptingSearch: Bool = false
    private var fullSearchSubmitted: Bool = false
    private var searchHasChanged: Bool = false
    
    func runSearch(query: String) async throws {
        guard !attemptingSearch else { return }

        searchInitialized = true
        attemptingSearch = true
        fullSearchSubmitted = true
        searchHasChanged = false
        lastSearch = query
        
        defer { attemptingSearch = false }
        
        let results = try await fetchSearchResults(query: query)
        searchResults = results
    }
    
    func getSearchResults() -> SearchResults? {
        searchResults
    }
    
    func getLastSearch() -> String {
        lastSearch
    }
    
    func getSearchInitialized() -> Bool {
        searchInitialized
    }
    
    func getAttemptingSearch() -> Bool {
        attemptingSearch
    }
    
    func getFullSearchSubmitted() -> Bool {
        fullSearchSubmitted
    }
    
    func getSearchHasChanged() -> Bool {
        searchHasChanged
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class SearchViewModel {
    private let viewActor = SearchViewActor()
    
    var searchResults: SearchResults? = nil
    var lastSearch: String = ""
    var searchInitialized: Bool = false
    var attemptingSearch: Bool = false
    var fullSearchSubmitted: Bool = false
    var searchHasChanged: Bool = false
    
    func runSearch(query: String) {
        Task {
            do {
                try await viewActor.runSearch(query: query)
                
                let results = await viewActor.getSearchResults()
                let lastSearch = await viewActor.getLastSearch()
                let searchInitialized = await viewActor.getSearchInitialized()
                let attemptingSearch = await viewActor.getAttemptingSearch()
                let fullSearchSubmitted = await viewActor.getFullSearchSubmitted()
                let searchHasChanged = await viewActor.getSearchHasChanged()
                
                await MainActor.run {
                    withAnimation {
                        self.searchResults = results
                        self.lastSearch = lastSearch
                        self.searchInitialized = searchInitialized
                        self.attemptingSearch = attemptingSearch
                        self.fullSearchSubmitted = fullSearchSubmitted
                        self.searchHasChanged = searchHasChanged
                    }
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    withAnimation {
                        self.searchResults = nil
                        self.attemptingSearch = false
                    }
                }
            }
        }
    }
    
    func runLastSearch() {
        runSearch(query: lastSearch)
    }
}
