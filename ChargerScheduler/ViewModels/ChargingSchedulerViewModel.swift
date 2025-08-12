//
//  ChargingSchedulerViewModel.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation
import SwiftUI

class ChargingSchedulerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var trucks: [Truck]
    @Published var chargers: [Charger]
    @Published var availableTimeWindow: Double
    
    @Published var schedule: ChargingSchedule?
    @Published var isScheduling: Bool = false
    @Published var selectedAlgorithm: SchedulingAlgorithm = .greedyTime
    
    // MARK: - Private Properties
    
    private var schedulers: [SchedulingAlgorithm: ChargingScheduler] = [
        .greedyTime: GreedyTimeScheduler(),
        .priorityQueue: HeapBasedScheduler()
    ]
    
    // MARK: - Scheduling Algorithms Enum
    
    enum SchedulingAlgorithm: String, CaseIterable, Identifiable {
        case greedyTime = "Greedy Approach"
        case priorityQueue = "MinHeap Approach"
        
        var id: String { rawValue }
        
        var description: String {
            switch self {
            case .greedyTime:
                return "Efficient truck allocation based on greedy approach"
            case .priorityQueue:
                return "Efficient truck allocation based on priority queue"
            }
        }
    }
    
    init() {
        // Initialize with sample data
        self.trucks = DataSamples.sampleTrucks
        self.chargers = DataSamples.sampleChargers
        self.availableTimeWindow = DataSamples.timeWindow
    }
    
    // MARK: - Methods
    
    func generateSchedule() {
        isScheduling = true
        
        // Simulate some processing time for better UX
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            let scheduler = schedulers[selectedAlgorithm] ?? GreedyTimeScheduler()
            let newSchedule = scheduler.schedule(
                trucks: self.trucks,
                chargers: self.chargers,
                timeWindow: self.availableTimeWindow
            )
            
            await MainActor.run {
                self.schedule = newSchedule
                self.isScheduling = false
            }
        }
    }
    
    func addTruck(capacity: Double, percent: Double) {
        let id = "Truck_\(trucks.count + 1)"
        trucks.append(Truck(id: id, batteryCapacity: capacity, currentChargeLevel: percent))
    }
    
    func addCharger(rate: Double) {
        let id = "Charger_\(chargers.count + 1)"
        chargers.append(Charger(id: id, chargingRate: rate))
    }
    
    func deleteTrucks(offsets: IndexSet) {
        trucks.remove(atOffsets: offsets)
    }
    
    func deleteChargers(offsets: IndexSet) {
        chargers.remove(atOffsets: offsets)
    }
    
    func resetToDefaults() {
        trucks = DataSamples.sampleTrucks
        chargers = DataSamples.sampleChargers
        availableTimeWindow = DataSamples.timeWindow
        schedule = nil
    }
}
