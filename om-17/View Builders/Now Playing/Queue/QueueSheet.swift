//
//  QueueSheet.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-12.
//

import SwiftUI

enum QueuePicks: String, CaseIterable, Identifiable {
    case played, queue
    var id: Self { self }
}

struct QueueSheet: View {
    @Environment(PlayerManager.self) var playerManager
    @Environment(FontManager.self) private var fontManager
    @State var selectedPick: QueuePicks = .queue
    @Binding var passedNSPath: NavigationPath
    @Binding var showingNPSheet: Bool
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Picker("Category", selection: $selectedPick.animation()) {
                    ForEach(QueuePicks.allCases) { option in
                        Text(option == .played ? "Played" : "Up Next")
                    }
                }
                    .pickerStyle(.segmented)
                Menu {
                    QueueMenu(selectedPick: $selectedPick)
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .customFont(fontManager, .title)
                }
            }
            if selectedPick == .played {
                QSHistory(passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
                Divider()
            }
            QSNPRow()
            if selectedPick == .queue {
                Divider()
                QSUpNext(passedNSPath: $passedNSPath, showingNPSheet: $showingNPSheet)
            }
        }
            .safeAreaPadding(.all)
            .safeAreaPadding(.top, 5)
    }
}

//#Preview {
//    NowPlayingSheet()
//    //QueueSheet()
//}
