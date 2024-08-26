//
//  LiveDownloadSum.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-04.
//

import SwiftUI

struct LiveDownloadSum: View {
    @Environment(DownloadManager.self) var downloadManager
    var body: some View {
        Group {
            if (downloadManager.sumProgression == 0) {
                Image(systemName: "circle.dashed")
                    .imageScale(.large)
            } else if (downloadManager.sumProgression < 1) {
                VStack {
                    CircularProgressView(progress: downloadManager.sumProgression)
                }
            } else if (downloadManager.sumProgression == 1) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .imageScale(.large)
            }
        }
    }
}
