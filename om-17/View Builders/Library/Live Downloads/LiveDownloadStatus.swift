//
//  LiveDownloadIcon.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-07-28.
//

import SwiftUI

struct LiveDownloadStatus: View {
    @Environment(DownloadManager.self) var downloadManager
    var download: DownloadData
    var body: some View {
        Group {
            switch download.state {
            case .waiting:
                Image(systemName: "circle.dashed")
                    .imageScale(.large)
            case .downloading:
                CircularProgressView(progress: download.progress)
            case .inactive:
                Image(systemName: "circle.slash")
                    .imageScale(.large)
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .imageScale(.large)
            case .cancelled:
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
            case .error:
                Menu {
                    Section(download.errorReason ?? "Unknown Error") {
                        Button {
                            downloadManager.retry_download(download: download)
                        } label: {
                            Label("Retry Download", systemImage: "arrow.circlepath")
                        }
                    }
                } label: {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundStyle(.red)
                        .imageScale(.large)
                        .padding(.all, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
    }
}
