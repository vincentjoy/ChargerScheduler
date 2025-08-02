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
                    
                    if !viewModel.trucks.isEmpty {
                        List {
                            ForEach(viewModel.trucks, id: \.id) { truck in
                                TruckConfigRow(truck: truck)
                            }
                            .onDelete(perform: viewModel.deleteTrucks)
                        }
                        .listStyle(.plain)
                        .frame(height: CGFloat(viewModel.trucks.count * 50))
                    }
                    
                    ChargerInputView(viewModel: viewModel)
                    
                    if !viewModel.chargers.isEmpty {
                        List {
                            ForEach(viewModel.chargers, id: \.id) { charger in
                                ChargerConfigRow(charger: charger)
                            }
                            .onDelete(perform: viewModel.deleteChargers)
                        }
                        .listStyle(.plain)
                        .frame(height: CGFloat(viewModel.chargers.count * 50))
                    }
                    
                    HStack {
                        Text("Total Time (hours)")
                        Stepper(value: $viewModel.availableTimeWindow, in: 1...24) {
                            Text("\(viewModel.availableTimeWindow) hrs")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        viewModel.resetToDefaults()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
