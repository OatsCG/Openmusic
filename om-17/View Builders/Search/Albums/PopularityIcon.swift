//
//  PopularityIcon.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-11-14.
//

import SwiftUI

struct PopularityIcon: View {
    var views: Int
    var min: Int?
    var max: Int?
    var chartWidth: Double = 15
    var chartCount: Double = 4
    var chartHeightMin: Double = 3
    var chartHeightMax: Double = 10
    var normalViews: Double = 0
    init(views: Int, min: Int?, max: Int?) {
        self.views = views
        self.min = min
        self.max = max
        if (min != nil && max != nil) {
            self.normalViews = normalizedViews(views: views, min: min!, max: max!)
        }
    }
    var body: some View {
        if (min != nil && max != nil) {
            HStack(alignment: .bottom, spacing: 0) {
                Image(systemName: "person.fill")
                    .customFont(.caption2)
                    .opacity(0.7)
                ForEach(1...Int(chartCount), id: \.self) { i in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(normalViews > (Double(i-1) / chartCount) ? .primary : .secondary)
                        .frame(
                            width: (chartWidth / chartCount) - 1,
                            height: ((chartHeightMax - chartHeightMin) / (chartCount - 1)) * (Double(i - 1)) + chartHeightMin
                        )
                        .padding(.all, 0.5)
                    
                }
            }
                .opacity(0.7)
        }
    }
}

func normalizedViews(views: Int, min: Int, max: Int) -> Double {
    let linear: Double = (Double(views - min) / Double(max - min))
    return pow(linear, 1/3)
}


#Preview {
    PopularityIcon(views: 905, min: 100, max: 1000)
        //.scaleEffect(5)
}
