//
//  Untitled.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-25.
//

import Foundation

extension DownloadManager {
    func downloadStarted(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.ds(downloader: downloader, task: task)
        }
    }
    
    func downloadCanceled(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.dc(downloader: downloader, task: task)
        }
    }
    
    func downloadFinished(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.df(downloader: downloader, task: task)
        }
    }
    
    func downloadProgressChanged(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.dpc(downloader: downloader, task: task)
        }
    }
    
    func downloadError(downloader: Downloader, task: DownloadTask, error: Error) {
        Task {
            await self.downloadActor.de(downloader: downloader, task: task, error: error)
        }
    }
    
}
