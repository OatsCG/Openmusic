//
//  TransitionWrapper.swift
//  om-17
//
//  Created by Charlie Giannis on 2026-02-05.
//

import SwiftUI

class TransitionWrapper: ObservableObject {
    var namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
