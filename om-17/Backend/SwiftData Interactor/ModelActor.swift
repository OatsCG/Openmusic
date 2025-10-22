//
//  ModelActor.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-06.
//

import Foundation
import SwiftData

@ModelActor
public actor ModelActorDatabase: Database {
    public func delete(_ model: some PersistentModel) async {
        modelContext.delete(model)
    }

    public func insert(_ model: some PersistentModel) async {
        modelContext.insert(model)
    }

    public func delete<T: PersistentModel>(where predicate: Predicate<T>?) async throws {
        try modelContext.delete(model: T.self, where: predicate)
    }

    public func save() async throws {
        try modelContext.save()
    }

    public func fetch<T>(_ descriptor: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
        return try modelContext.fetch(descriptor)
    }
}
