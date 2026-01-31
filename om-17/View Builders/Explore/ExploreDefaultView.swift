//
//  ExploreDefaultView.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-31.
//

import SwiftUI

struct ExploreDefaultView: View {
    @Binding var viewModel: ExploreViewModel
    var body: some View {
        if let firstShelf = viewModel.exploreResults?.Shelves.first, !firstShelf.Albums.isEmpty {
            ExploreShelfBigView(exploreShelf: firstShelf)
        }
        Divider()
            .padding(.bottom, 15)
        if let results = viewModel.exploreResults {
            ForEach(results.Shelves.dropFirst(), id: \.self) { shelf in
                if !shelf.Albums.isEmpty {
                    ExploreShelfView(exploreShelf: shelf)
                    Divider()
                        .padding(.bottom, 15)
                }
            }
        }
    }
}
