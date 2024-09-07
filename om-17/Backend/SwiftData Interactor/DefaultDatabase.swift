//
//  DefaultDatabase.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-09-06.
//

import Foundation
import SwiftData
import SwiftUI

struct DefaultDatabase: Database {
  struct NotImplmentedError: Error {
    static let instance = NotImplmentedError()
  }

  static let instance = DefaultDatabase()

  func fetch<T>(_: FetchDescriptor<T>) async throws -> [T] where T: PersistentModel {
    assertionFailure("No Database Set.")
    throw NotImplmentedError.instance
  }

    func delete<T>(where predicate: Predicate<T>?) async throws where T : PersistentModel {
        assertionFailure("No Database Set.")
    }
    func delete<T>(_ model: T) async where T : PersistentModel {
        assertionFailure("No Database Set.")
    }

  func insert(_: some PersistentModel) async {
    assertionFailure("No Database Set.")
  }

  func save() async throws {
    assertionFailure("No Database Set.")
    throw NotImplmentedError.instance
  }
}




