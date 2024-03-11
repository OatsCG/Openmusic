//
//  VStackWrapped.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-27.
//

import SwiftUI

struct VStackWrapped<Content: View>: View {
    let columns: Int
    let content: Content
    
    init(columns: Int, @ViewBuilder content: () -> Content) {
        self.columns = columns
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                content
             }
        }
    }
}

#Preview {
    ExplorePage(exploreNSPath: .constant(NavigationPath()))
}
