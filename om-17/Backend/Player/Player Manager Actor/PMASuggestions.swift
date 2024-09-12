////
////  PMASuggestions.swift
////  om-17
////
////  Created by Charlie Giannis on 2024-08-28.
////
//
//extension PlayerManagerActor {
//    func trySuggestingPlaylistCreation() async {
//        if (self.shouldSuggestPlaylistCreation == true) {
//            return
//        } else {
//            if (self.hasSuggestedPlaylistCreation == true) {
//                return
//            } else {
//                // get sessionHistory queueItems that were enjoyed
//                var enjoyedHistory: [QueueItem] = []
//                for queueItem in self.sessionHistory {
//                    if await queueItem.wasSongEnjoyed {
//                        enjoyedHistory.append(queueItem)
//                    }
//                }
//                
//                let enjoyedCount: Int = enjoyedHistory.count
//                if (enjoyedCount > 10) {
//                    // get enjoyedHistory tracks that are imports
//                    var importedTracks: [ImportedTrack] = []
//                    for track in enjoyedHistory {
//                        if let importedTrack = await track.Track as? ImportedTrack {
//                            importedTracks.append(importedTrack)
//                        }
//                    }
//                    
//                    let importedCount: Int = importedTracks.count
//                    if (importedCount > 10) {
//                        self.shouldSuggestPlaylistCreation = true
//                    }
//                }
//            }
//        }
//    }
//}
