//
//  Credits.swift
//  om-17
//
//  Created by Charlie Giannis on 2024-02-02.
//

import SwiftUI

struct Credits: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    Text("Openmusic")
                        .font(.largeTitle .bold())
                    VStack(spacing: 5) {
                        Text("for the pursuit of open data")
                            .font(.title2 .bold())
                        Capsule().fill(.bar)
                            .frame(width: 100, height: 5)
                        Text("with love to everyone who contributed.")
                            .font(.title3 .bold())
                    }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    Divider()
                        .padding(.bottom, 5)
                    Text("Team Members")
                        .font(.title .bold())
                        .padding(.bottom, 5)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Charlie Giannis")
                                .font(.title3 .bold())
                            VStack(alignment: .leading) {
                                Text("• Lead Programmer")
                                Text("• Lead Designer")
                            }
                                .font(.footnote)
                        }
                        .padding(.bottom, 5)
                        VStack(alignment: .leading) {
                            Text("XXXXX")
                                .font(.title3 .bold())
                            VStack(alignment: .leading) {
                                Text("• Programming")
                                Text("• Graphic Design")
                                Text("• Networking")
                            }
                                .font(.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text("XXXXX")
                                .font(.title3 .bold())
                            VStack(alignment: .leading) {
                                Text("• Programming")
                                Text("• Graphic Design")
                                Text("• Database")
                            }
                                .font(.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text("XXXXX")
                                .font(.title3 .bold())
                            VStack(alignment: .leading) {
                                Text("• Graphic Design")
                                Text("• Tester")
                            }
                                .font(.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text("XXXXX")
                                .font(.title3 .bold())
                            VStack(alignment: .leading) {
                                Text("• Graphic Design")
                                Text("• Tester")
                            }
                                .font(.footnote)
                        }
                        VStack(alignment: .leading) {
                            Text("XXXXX")
                                .font(.title3 .bold())
                            VStack(alignment: .leading) {
                                Text("• Input Contributor")
                                Text("• Tester")
                            }
                                .font(.footnote)
                        }
                    }
                    
                }
            }
        }
            .scrollContentBackground(.hidden)
            .navigationTitle("Credits")
            .navigationBarTitleDisplayMode(.inline)
            .background {
                GlobalBackground_component()
            }
    }
}

#Preview {
    Credits()
}
