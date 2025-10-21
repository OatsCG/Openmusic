//
//  QueueOptions.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-03-24.
//

import SwiftUI

struct QueueOptions: View {
    @AppStorage("DisableQueuingSuggestions") var DisableQueuingSuggestions: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    Toggle("Disable Queuing Suggestions", isOn: $DisableQueuingSuggestions)
                        .tint(.green)
                }, header: {
                    Text("SUGGESTIONS")
                }, footer: {
                    Text("Prevent Openmusic from auto-queuing suggested music.")
                })
            }
                .scrollContentBackground(.hidden)
                .navigationTitle("Queue")
                .navigationBarTitleDisplayMode(.inline)
                .background {
                    GlobalBackground_component()
                }
        }
    }
}

#Preview {
    QueueOptions()
}
