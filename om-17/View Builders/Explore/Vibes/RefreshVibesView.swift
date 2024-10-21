//
//  RefreshVibesView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-10-21.
//

import SwiftUI

struct RefreshVibesView: View {
    @Binding var refreshAnimateCount: Int
    var body: some View {
        Image(systemName: "arrow.clockwise")
            .resizable()
            .scaledToFit()
            .symbolEffect(.rotate, value: refreshAnimateCount)
            .frame(width: 45, height: 45)
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.thinMaterial)
            }
    }
}
