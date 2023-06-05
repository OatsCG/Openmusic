//
//  om_17App.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-05.
//

import SwiftUI
import SwiftData

@main
struct om_17App: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
