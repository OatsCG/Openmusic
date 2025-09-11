//
//  QuickFetchAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

// Function to fetch quick search results
func fetchQuickSearchResults(query: String) async throws -> FetchedTracks {
    let urlString = NetworkManager.shared.networkService.getEndpointURL(.quick(q: query))
    
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    return try NetworkManager.shared.networkService.decodeFetchedTracks(data)
}

// Actor to manage quick search data
actor QuickSearchViewActor {
    private var fetchedTracks: FetchedTracks? = nil
    private var lastSearch: String = ""
    private var searchInitialized: Bool = false
    private var attemptingSearch: Bool = false
    
    func runSearch(query: String) async throws {
        guard !attemptingSearch else { return }
        
        searchInitialized = true
        attemptingSearch = true
        lastSearch = query
        
        defer { attemptingSearch = false }
        
        let tracks = try await fetchQuickSearchResults(query: query)
        self.fetchedTracks = tracks
    }
    
    func getFetchedTracks() -> FetchedTracks? {
        return fetchedTracks
    }
    
    func getLastSearch() -> String {
        return lastSearch
    }
    
    func getSearchInitialized() -> Bool {
        return searchInitialized
    }
    
    func getAttemptingSearch() -> Bool {
        return attemptingSearch
    }
}

// ViewModel to manage view updates
@MainActor
@Observable class QuickSearchViewModel {
    private let viewActor = QuickSearchViewActor()
    
    var fetchedTracks: FetchedTracks? = nil
    var lastSearch: String = ""
    var searchInitialized: Bool = false
    var attemptingSearch: Bool = false
    
    func runSearch(query: String) {
        Task {
            do {
                try await viewActor.runSearch(query: query)
                
                let tracks = await viewActor.getFetchedTracks()
                let lastSearch = await viewActor.getLastSearch()
                let searchInitialized = await viewActor.getSearchInitialized()
                let attemptingSearch = await viewActor.getAttemptingSearch()
                
                await MainActor.run {
                    withAnimation(.interactiveSpring(duration: 0.3)) {
                        self.fetchedTracks = tracks
                        self.lastSearch = lastSearch
                        self.searchInitialized = searchInitialized
                        self.attemptingSearch = attemptingSearch
                    }
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    withAnimation(.interactiveSpring(duration: 0.3)) {
                        self.fetchedTracks = nil
                        self.attemptingSearch = false
                    }
                }
            }
        }
    }
    
    func runLastSearch() {
        self.runSearch(query: self.lastSearch)
    }
}
