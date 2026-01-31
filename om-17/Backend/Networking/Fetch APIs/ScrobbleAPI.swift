//
//  ScrobbleAPI.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-01-31.
//

import Foundation

func pushScrobble(id: String, enjoyed: Bool) async throws {
    try await NetworkManager.shared.fetch(endpoint: .scrobble(id: id, enjoyed: enjoyed), type: Data.self)
}
