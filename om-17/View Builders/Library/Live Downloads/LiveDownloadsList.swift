//
//  LiveDownloadsView.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-12.
//

import SwiftUI
import SwiftData

struct LiveDownloadsList: View {
    @Environment(DownloadManager.self) var downloadManager
    @State var expanded: Bool = false
    var body: some View {
        if (downloadManager.tracksDownloading.count > 0) {
            VStack {
                Button(action: {
                    withAnimation {
                        self.expanded = !self.expanded
                    }
                }) {
                    HStack {
                        Text("Downloading")
                        Image(systemName: expanded ? "chevron.up.circle" : "chevron.down.circle")
                            .contentTransition(.symbolEffect(.replace.offUp))
                        Spacer()
                        LiveDownloadSum()
                            .frame(height: 40)
                    }
                        .padding(10)
                }
                    .foregroundStyle(.primary)
                    //.padding(.all, 10)
                    .background(.thinMaterial)
                List {
                    ForEach(downloadManager.tracksDownloading, id: \.id) { download in
                        LiveDownloadRow(download: download)
                    }
                }
                    .listStyle(PlainListStyle())
            }
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .containerRelativeFrame(.vertical, count: 10, span: expanded ? 8 : 4, spacing: 0)
        }
    }
}
