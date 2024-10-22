//
//  FilterMenu.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-10-21.
//

import SwiftUI

struct FilterMenu: View {
    @Binding var selectedPickMusic: MusicPicks
    @Binding var albumSortType: LibrarySortType
    @Binding var songSortType: LibrarySortType
    @Binding var artistSortType: LibrarySortType
    @Binding var filterDownloaded: Bool
    var body: some View {
        Menu {
            Section("Sort By") {
                Button(action: {
                    switch selectedPickMusic {
                    case .albums:
                        albumSortType = albumSortType == .date_up ? .date_down : .date_up
                    case .songs:
                        songSortType = songSortType == .date_up ? .date_down : .date_up
                    case .artists:
                        artistSortType = artistSortType == .date_up ? .date_down : .date_up
                    }
                }) {
                    switch selectedPickMusic {
                    case .albums:
                        Label("Date Added", systemImage: albumSortType == .date_down ? "arrow.down" : (albumSortType == .date_up ? "arrow.up" : ""))
                    case .songs:
                        Label("Date Added", systemImage: songSortType == .date_down ? "arrow.down" : (songSortType == .date_up ? "arrow.up" : ""))
                    case .artists:
                        Label("Date Added", systemImage: artistSortType == .date_down ? "arrow.down" : (artistSortType == .date_up ? "arrow.up" : ""))
                    }
                }
                Button(action: {
                    switch selectedPickMusic {
                    case .albums:
                        albumSortType = albumSortType == .title_up ? .title_down : .title_up
                    case .songs:
                        songSortType = songSortType == .title_up ? .title_down : .title_up
                    case .artists:
                        artistSortType = artistSortType == .title_up ? .title_down : .title_up
                    }
                }) {
                    switch selectedPickMusic {
                    case .albums:
                        Label("Alphabetical", systemImage: albumSortType == .title_down ? "arrow.down" : (albumSortType == .title_up ? "arrow.up" : ""))
                    case .songs:
                        Label("Alphabetical", systemImage: songSortType == .title_down ? "arrow.down" : (songSortType == .title_up ? "arrow.up" : ""))
                    case .artists:
                        Label("Alphabetical", systemImage: artistSortType == .title_down ? "arrow.down" : (artistSortType == .title_up ? "arrow.up" : ""))
                    }
                }
            }
            Section("Filter") {
                Button(action: {
                    filterDownloaded.toggle()
                }) {
                    Label("Downloaded", systemImage: filterDownloaded ? "checkmark" : "")
                }
            }
            Section {
                Button(role: .destructive, action: {
                    filterDownloaded = false
                    albumSortType = .date_up
                    songSortType = .date_up
                    artistSortType = .title_up
                }) {
                    Label("Clear Filters", systemImage: "minus.circle")
                }
            }
            
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
                .font(.body)
        }
    }
}

// x_up meaning highest first
enum LibrarySortType {
    case date_up, date_down, title_up, title_down
}
