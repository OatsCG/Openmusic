//
//  UserView.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-04.
//

import SwiftUI

struct UserView: View {
    @Environment(FontManager.self) private var fontManager
    @Environment(OMUser.self) var omUser
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("User ID:")
                    .customFont(fontManager, .title3, bold: true)
                Text("\(omUser.userID)")
                    .customFont(fontManager, .headline)
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
