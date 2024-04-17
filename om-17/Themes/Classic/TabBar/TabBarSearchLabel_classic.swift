//
//  TabBarSearchLabel_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TabBarSearchLabel_classic: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
    }
}

#Preview {
    TabBarSearchLabel_classic()
}
