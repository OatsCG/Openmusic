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
            await downloadActor.ds(downloader: downloader, task: task)
            await updateUI()
        }
    }
    
    func downloadCanceled(downloader: Downloader, task: DownloadTask) {
        Task {
            await downloadActor.dc(downloader: downloader, task: task)
            await updateUI()
        }
    }
    
    func downloadFinished(downloader: Downloader, task: DownloadTask) {
        Task {
            await downloadActor.df(downloader: downloader, task: task)
            await updateUI()
        }
    }
    
    func downloadProgressChanged(downloader: Downloader, task: DownloadTask) {
        Task {
            await downloadActor.dpc(downloader: downloader, task: task)
            await updateUI()
        }
    }
    
    func downloadError(downloader: Downloader, task: DownloadTask, error: Error) {
        Task {
            await downloadActor.de(downloader: downloader, task: task, error: error)
            await updateUI()
        }
    }
}
