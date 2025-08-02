//
//  ContentView.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ChargingSchedulerViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    
                    TruckInputView(viewModel: viewModel)
                    
                    List {
                        ForEach(viewModel.dataManager.trucks, id: \.id) { truck in
                            TruckConfigRow(truck: truck)
                        }
                        .onDelete(perform: viewModel.deleteTrucks)
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(viewModel.dataManager.trucks.count * 50))
                    
                    ChargerInputView(viewModel: viewModel)
                    
                    List {
                        ForEach(viewModel.dataManager.chargers, id: \.id) { charger in
                            ChargerConfigRow(charger: charger)
                        }
                        .onDelete(perform: viewModel.deleteChargers)
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(viewModel.dataManager.chargers.count * 50))
                    
                    HStack {
                        Text("Total Time (hours)")
                        Stepper(value: $viewModel.dataManager.availableTimeWindow, in: 1...24) {
                            Text("\(viewModel.dataManager.availableTimeWindow) hrs")
                        }
                    }
                    
                    Button("Generate Schedule") {
                        viewModel.generateSchedule()
                    }
                    
                    if let schedule = viewModel.schedule {
                        Divider()
                        AllocationChartView(schedule: schedule)
                    }
                }
                .padding()
            }
            .navigationTitle("Truck Charging Scheduler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
