//
//  DownloadManagerActor.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-08-25.
//

import Foundation

actor DownloadManagerActor {
    let downloader = Downloader()
    let maxDownloads = 8
    var currentlyDownloading = 0
    var tracksDownloading: [DownloadData] = []
    var tracksLookup: [String: UUID] = [:]
    
    func addDownloadTask(track: any Track, explicit: Bool) async {
        let playbackID = explicit ? track.Playback_Explicit! : track.Playback_Clean!
        guard !isPlaybackDownloaded(playbackID: playbackID), tracksLookup[playbackID] == nil else { return }
        
        let downloadData = DownloadData(track: track, explicit: explicit)
        downloadData.state = .waiting
        tracksLookup[playbackID] = downloadData.id
        tracksDownloading.append(downloadData)
        await tryNextDownload()
    }
    
    func tryNextDownload() async {
        guard currentlyDownloading < maxDownloads else { return }
        
        if let nextDownload = tracksDownloading.first(where: { $0.state == .waiting }) {
            await beginDownload(downloadData: nextDownload)
        }
    }
    
    func beginDownload(downloadData: DownloadData) async {
        currentlyDownloading += 1
        downloadData.state = .fetching
        
        if let downloadURL = await getDownloadURL(playbackID: downloadData.playbackID) {
            let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent("Audio-\(downloadData.playbackID).mp4")
            
            if let destination = destination {
                let newTask = DownloadTask(dID: downloadData.playbackID, source: downloadURL, destination: destination)
                downloadData.downloadTask = newTask
                downloader.start(newTask)
            }
        } else {
            downloadData.state = .error
            downloadData.errorReason = "Couldn't retrieve download link"
        }
        
        currentlyDownloading -= 1
        await tryNextDownload()
    }
    
    func cancelDownload(playbackID: String) {
        if let task = findTask(playbackID: playbackID) {
            downloader.cancel(task)
        }
    }
    
    func retryDownload(download: DownloadData) async {
        self.tracksLookup.removeValue(forKey: download.playbackID)
        self.tracksDownloading.removeAll(where: {$0.id == download.id})
        await self.addDownloadTask(track: download.parent, explicit: download.explicit)
    }
    
    private func getDownloadURL(playbackID: String) async -> URL? {
        do {
            let fetchedData = try await fetchPlaybackData(playbackID: playbackID)
            return fetchedData.Playback_Audio_URL.isEmpty ? nil : URL(string: fetchedData.Playback_Audio_URL)
        } catch {
            return nil
        }
    }
    
    private func findTask(playbackID: String) -> DownloadTask? {
        return downloader.tasks.first(where: { $0.value.dID == playbackID })?.value
    }
    
    func isPlaybackDownloaded(playbackID: String?) -> Bool {
        if let playbackID = playbackID {
            let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent("Audio-\(playbackID).mp4")
            let doesExist = FileManager.default.fileExists(atPath: destination?.path ?? "")
            return doesExist
        } else {
            return false
        }
    }
    
    // OTHER STUFFS FOR MANAGING, NOT DOWNLOADING
    func get_sum_progression() -> Double {
        var sum: Double = 0
        for dl in self.tracksDownloading {
            sum += dl.progress
        }
        return (sum / Double(self.tracksDownloading.count))
    }
    
    // DELEGATE STUFFS
    func taskID_to_tracks_downloading(taskID: UUID?) -> DownloadData? {
        let firstTask: DownloadData? = self.tracksDownloading.first(where: { $0.id == taskID })
        return firstTask
    }
    
    func ds(downloader: Downloader, task: DownloadTask) {
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.state = .downloading
    }
    func dc(downloader: Downloader, task: DownloadTask) async {
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.state = .cancelled
        await self.tryNextDownload()
    }
    func df(downloader: Downloader, task: DownloadTask) async {
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.state = .success
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.location = task.destination
        self.currentlyDownloading -= 1
        do {
            self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.size = try FileManager.default.attributesOfItem(atPath: task.destination.path())[.size] as! Int
        } catch {
            self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.size = -1
        }
        await self.tryNextDownload()
    }
    func dpc(downloader: Downloader, task: DownloadTask) {
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.progress = task.progress // ISSUE HERE GETTING PROGRESS
    }
    func de(downloader: Downloader, task: DownloadTask, error: Error) async {
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.state = .error
        self.taskID_to_tracks_downloading(taskID: self.tracksLookup[task.dID])?.errorReason = error.localizedDescription
        self.currentlyDownloading -= 1
        await self.tryNextDownload()
    }
}

