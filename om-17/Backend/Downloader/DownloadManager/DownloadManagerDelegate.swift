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
            await self.updateUI()
        }
    }
    
    func downloadCanceled(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.dc(downloader: downloader, task: task)
            await self.updateUI()
        }
    }
    
    func downloadFinished(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.df(downloader: downloader, task: task)
            await self.updateUI()
        }
    }
    
    func downloadProgressChanged(downloader: Downloader, task: DownloadTask) {
        Task {
            await self.downloadActor.dpc(downloader: downloader, task: task)
            await self.updateUI()
        }
    }
    
    func downloadError(downloader: Downloader, task: DownloadTask, error: Error) {
        Task {
            await self.downloadActor.de(downloader: downloader, task: task, error: error)
            await self.updateUI()
        }
    }
    
}
