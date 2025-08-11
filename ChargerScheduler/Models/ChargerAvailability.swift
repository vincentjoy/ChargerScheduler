//
//  ChargerAvailability.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 11/08/25.
//

// Helper struct for priority queue
struct ChargerAvailability: Comparable {
    let charger: Charger
    var availableAt: Double
    
    static func < (lhs: ChargerAvailability, rhs: ChargerAvailability) -> Bool {
        if lhs.availableAt == rhs.availableAt {
            // Secondary sort by charging rate (higher is better)
            return lhs.charger.chargingRate > rhs.charger.chargingRate
        }
        return lhs.availableAt < rhs.availableAt
    }
}
