//
//  DataManager.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

/**
 * Manages sample data and configuration for the charging scheduler
 * This is where you can easily modify input data for testing different scenarios
 */
class DataManager: ObservableObject {
    
    // MARK: - Sample Data Configuration
    
    static let sampleTrucks: [Truck] = [
        Truck(id: "Truck_1", batteryCapacity: 150.0, currentChargeLevel: 20.0),
        Truck(id: "Truck_2", batteryCapacity: 200.0, currentChargeLevel: 15.0),
        Truck(id: "Truck_3", batteryCapacity: 100.0, currentChargeLevel: 50.0),
        Truck(id: "Truck_4", batteryCapacity: 175.0, currentChargeLevel: 30.0),
        Truck(id: "Truck_5", batteryCapacity: 120.0, currentChargeLevel: 10.0),
        Truck(id: "Truck_6", batteryCapacity: 180.0, currentChargeLevel: 25.0),
        Truck(id: "Truck_7", batteryCapacity: 90.0, currentChargeLevel: 80.0),
        Truck(id: "Truck_8", batteryCapacity: 160.0, currentChargeLevel: 40.0),
    ]
    
    static let sampleChargers: [Charger] = [
        Charger(id: "Charger_1", chargingRate: 50.0),
        Charger(id: "Charger_2", chargingRate: 75.0),
        Charger(id: "Charger_3", chargingRate: 100.0),
        Charger(id: "Charger_4", chargingRate: 25.0),
    ]
    
    static let timeWindow: Double = 8.0 // 8 hours overnight
    
    // MARK: - Dynamic Data Properties
    
    @Published var trucks: [Truck]
    @Published var chargers: [Charger]
    @Published var availableTimeWindow: Double
    
    init() {
        self.trucks = Self.sampleTrucks
        self.chargers = Self.sampleChargers
        self.availableTimeWindow = Self.timeWindow
    }
    
    // MARK: - Data Modification Methods
    
    func resetToDefaults() {
        trucks = Self.sampleTrucks
        chargers = Self.sampleChargers
        availableTimeWindow = Self.timeWindow
    }
    
    func addTruck(_ truck: Truck) {
        trucks.append(truck)
    }
    
    func removeTruck(withId id: String) {
        trucks.removeAll { $0.id == id }
    }
    
    func addCharger(_ charger: Charger) {
        chargers.append(charger)
    }
    
    func removeCharger(withId id: String) {
        chargers.removeAll { $0.id == id }
    }
}
