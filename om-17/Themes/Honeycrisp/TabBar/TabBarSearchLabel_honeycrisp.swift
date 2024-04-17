//
//  TabBarSearchLabel_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TabBarSearchLabel_honeycrisp: View {
    @Binding var selectionBinding: Int
    var body: some View {
        Label("Search", systemImage: "magnifyingglass")
            .foregroundColor(selectionBinding == 1 ? Color.blue : Color.red)
            .blendMode(.darken)
    }
}
