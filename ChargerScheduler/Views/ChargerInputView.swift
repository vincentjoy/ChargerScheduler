//
//  ChargerInputView.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct ChargerInputView: View {
    @ObservedObject var viewModel: ChargingSchedulerViewModel
    @State private var rate = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Charger")
            HStack {
                TextField("Rate (kW)", text: $rate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add") {
                    if let r = Double(rate) {
                        viewModel.addCharger(rate: r)
                        rate = ""
                    }
                }
            }
        }
    }
}
