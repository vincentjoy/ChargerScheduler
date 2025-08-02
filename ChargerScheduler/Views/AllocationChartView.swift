//
//  AllocationChartView.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct AllocationChartView: View {
    let schedule: ChargingSchedule

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(schedule.sessionsByCharger.keys), id: \.self) { key in
                HStack {
                    Text(key)
                        .frame(width: 100, alignment: .leading)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(schedule.sessionsByCharger[key]!, id: \.self) { truck in
                                Rectangle()
                                    .fill(Color.random)
                                    .frame(width: 50, height: 20)
                                    .overlay(Text(truck.id).font(.caption2).foregroundColor(.white))
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(hue: .random(in: 0...1),
                     saturation: 0.6,
                     brightness: 0.9)
    }
}
