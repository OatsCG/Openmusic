//
//  GlobalBackground_honeycrisp.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-10-02.
//

import SwiftUI

struct GlobalBackground_honeycrisp: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            if (colorScheme == .dark) {
                Color(.black)
            } else {
                Color(.white)
            }
        }
            .ignoresSafeArea()
    }
}

#Preview {
    GlobalBackground_honeycrisp()
}
