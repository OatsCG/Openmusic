//
//  UserView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-04.
//

import SwiftUI

struct UserView: View {
    @Environment(OMUser.self) var omUser
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("User ID:")
                    .customFont(.title3, bold: true)
                Text("\(omUser.userID)")
                    .customFont(.headline)
                    .multilineTextAlignment(.leading)
            }
            
        }
            .navigationTitle("Profile")
    }
}

#Preview {
    return NavigationStack {
        UserView()
            .environment(OMUser())
    }
}
