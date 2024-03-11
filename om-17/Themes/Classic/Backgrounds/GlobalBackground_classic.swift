//
//  globalBackground_classic.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_classic: View {
    var body: some View {
        VStack {
            Color(.systemFill).opacity(0.3)
        }
            .ignoresSafeArea()
    }
}

#Preview {
    GlobalBackground_classic()
}
