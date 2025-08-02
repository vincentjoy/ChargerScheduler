//
//  Truck.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

struct Truck: Identifiable, Hashable {
    let id: String
    let batteryCapacity: Double // in kWh
    let currentChargeLevel: Double // percentage
    
    init(id: String, batteryCapacity: Double, currentChargeLevel: Double) {
        self.id = id
        self.batteryCapacity = batteryCapacity
        self.currentChargeLevel = min(max(currentChargeLevel, 0), 100) // Clamp between 0-100
    }
    
    var energyNeededToFull: Double {
        return batteryCapacity * (1 - currentChargeLevel / 100)
    }
    
    func timeToFullCharge(using charger: Charger) -> Double? {
        guard currentChargeLevel < 100 else { return nil }
        return energyNeededToFull / charger.chargingRate
    }
    
    var isFullyCharged: Bool {
        return currentChargeLevel >= 100
    }
}
