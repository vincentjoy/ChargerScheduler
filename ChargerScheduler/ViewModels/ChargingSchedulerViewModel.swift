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
    
    @Published var schedule: ChargingSchedule?
    @Published var isScheduling: Bool = false
    @Published var selectedAlgorithm: SchedulingAlgorithm = .greedyTime
    @Published var dataManager = DataManager()
    
    // MARK: - Private Properties
    
    private var schedulers: [SchedulingAlgorithm: ChargingScheduler] = [
        .greedyTime: GreedyTimeScheduler(),
        .highestEnergyFirst: HighestEnergyFirstScheduler()
    ]
    
    // MARK: - Scheduling Algorithms Enum
    
    enum SchedulingAlgorithm: String, CaseIterable, Identifiable {
        case greedyTime = "Greedy (Shortest Time First)"
        case highestEnergyFirst = "Highest Energy First"
        
        var id: String { rawValue }
        
        var description: String {
            switch self {
            case .greedyTime:
                return "Prioritizes trucks that can be charged fastest"
            case .highestEnergyFirst:
                return "Prioritizes trucks with highest energy requirements"
            }
        }
    }
    
    // MARK: - Methods
    
    func generateSchedule() {
        isScheduling = true
        
        // Simulate some processing time for better UX
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            let scheduler = schedulers[selectedAlgorithm] ?? GreedyTimeScheduler()
            let newSchedule = scheduler.schedule(
                trucks: dataManager.trucks,
                chargers: dataManager.chargers,
                timeWindow: dataManager.availableTimeWindow
            )
            
            await MainActor.run {
                self.schedule = newSchedule
                self.isScheduling = false
            }
        }
    }
    
    func clearSchedule() {
        schedule = nil
    }
    
    func addTruck(capacity: Double, percent: Double) {
        let id = "Truck_\(dataManager.trucks.count + 1)"
        dataManager.addTruck(Truck(id: id, batteryCapacity: capacity, currentChargeLevel: percent))
    }
    
    func addCharger(rate: Double) {
        let id = "Charger_\(dataManager.chargers.count + 1)"
        dataManager.addCharger(Charger(id: id, chargingRate: rate))
    }
}
