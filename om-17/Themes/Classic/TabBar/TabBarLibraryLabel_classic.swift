//
//  TabBarLibraryLabel_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-08-06.
//

import SwiftUI

struct TabBarLibraryLabel_classic: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "book")
            Text("Library")
        }
    }
}

#Preview {
    TabBarLibraryLabel_classic()
}
