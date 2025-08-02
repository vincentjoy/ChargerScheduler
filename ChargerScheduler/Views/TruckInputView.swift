//
//  TruckInputView.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct TruckInputView: View {
    @ObservedObject var viewModel: ChargingSchedulerViewModel
    @State private var capacity = ""
    @State private var charge = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Truck")
            HStack {
                TextField("Capacity (kWh)", text: $capacity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Charge %", text: $charge)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add") {
                    if let cap = Double(capacity), let perc = Double(charge) {
                        viewModel.addTruck(capacity: cap, percent: perc)
                        capacity = ""
                        charge = ""
                    }
                }
            }
        }
    }
}
