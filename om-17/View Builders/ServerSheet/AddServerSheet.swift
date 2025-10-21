//
//  AddServerSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-21.
//

import SwiftUI

struct AddServerSheet: View {
    @Environment(FontManager.self) private var fontManager
    @AppStorage("globalIPAddress") var globalIPAddress: String = ""
    @Binding var showingServerSheet: Bool
    @State var inputIPAddress: String = ""
    @State var viewModel: StatusViewModel = StatusViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Input your Server URL Here.")
                    .customFont(fontManager, .title2, bold: true)
                    .padding(.top, 50)
                Text("For help with servers, visit\n**[create.openmusic.app](https://create.openmusic.app)**")
                    .customFont(fontManager, .subheadline)
                    .padding(.bottom, 5)
                VStack {
                    ServerInput(inputIPAddress: $inputIPAddress, viewModel: $viewModel)
                    ServerDescription(viewModel: $viewModel)
                }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.quinary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                if viewModel.serverStatus?.online == true {
                    Text("By clicking **Add Server**, you are stating that the server “\(viewModel.finalIPAddress)” and all of its content (audio files, images, titles, etc) are owned by you.\n\nYou are also giving permission for the Openmusic app to display and play your content, as well as to use your server’s endpoints for suggestions and discovery features.")
                }
                AddServerButton(showingServerSheet: $showingServerSheet, viewModel: $viewModel)
                Text("You can change the server later in Options.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
            .safeAreaPadding(.all, 20)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    AddServerSheet(showingServerSheet: .constant(true))
}
