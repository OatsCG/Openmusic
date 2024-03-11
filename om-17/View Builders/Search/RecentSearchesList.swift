//
//  RecentSearchesList.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-13.
//

import SwiftUI

struct RecentSearchesList: View {
    @SceneStorage("recentSearches") var recentSearches: String = "search #1<!SPLITRECENTS!>search #2<!SPLITRECENTS!>search #3"
    @Binding var viewModel: SearchViewModel
    @Binding var searchField: String
    var body: some View {
        if recentSearches == "" {
            ContentUnavailableView {
                Label("", systemImage: "magnifyingglass")
            } description: {
                Text("Recent searches will appear here.")
            }
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Text("Recently Searched")
                        .customFont(.title2, bold: true)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            recentSearches = ""
                        }
                    }) {
                        Text("Clear")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                        .buttonStyle(.plain)
                        .disabled(recentSearches == "")
                }
                Divider()
                ForEach(Array(parse_recents(recents: recentSearches).reversed().enumerated()), id: \.offset) { index, search in
                    Button(action: {
                        searchField = search
                        withAnimation {
                            viewModel.searchHasChanged = true
                        }
                    }) {
                        HStack {
                            Label(search, systemImage: "arrow.up.right.square")
                                .customFont(.headline)
                            Spacer()
                        }
                    }
                        .buttonStyle(.plain)
                        .padding(.vertical, 8)
                    Divider()
                }
            }
                .padding(.horizontal, 20)
        }
    }
}

//
//#Preview {
//    RecentSearchesList()
//}
