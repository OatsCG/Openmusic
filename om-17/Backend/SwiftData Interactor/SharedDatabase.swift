//
//  SharedDatabase.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-06.
//

import Foundation
import SwiftData

@MainActor @Observable
public class SharedDatabase {
    public static let shared: SharedDatabase = .init(schemas: [StoredTrack.self, StoredPlaylist.self])
    public let schemas: [any PersistentModel.Type]
    public let modelContainer: ModelContainer
    public let database: BackgroundDatabase

    private init(
        schemas: [any PersistentModel.Type] = []
    ) {
        self.schemas = schemas
        self.modelContainer = try! ModelContainer(for: StoredTrack.self, StoredPlaylist.self)
        database = BackgroundDatabase(modelContainer: modelContainer)
    }
}
