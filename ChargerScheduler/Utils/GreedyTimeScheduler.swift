//
//  GreedyTimeScheduler.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

/**
 Greedy scheduling algorithm that prioritizes trucks requiring least charging time
*/

class GreedyTimeScheduler: ChargingScheduler {
    
    func schedule(trucks: [Truck], chargers: [Charger], timeWindow: Double) -> ChargingSchedule {
        // Filter out trucks that are already fully charged
        let trucksNeedingCharge = trucks.filter { !$0.isFullyCharged }
        
        // Track when each charger becomes available
        var chargerAvailability: [String: Double] = [:]
        for charger in chargers {
            chargerAvailability[charger.id] = 0.0
        }
        
        var sessions: [ChargingSession] = []
        
        // Create charging options: (truck, charger, time_required)
        var chargingOptions: [(Truck, Charger, Double)] = []
        
        for truck in trucksNeedingCharge {
            for charger in chargers {
                if let timeRequired = truck.timeToFullCharge(using: charger) {
                    chargingOptions.append((truck, charger, timeRequired))
                }
            }
        }
        
        // Sort by charging time (greedy: shortest time first)
        chargingOptions.sort { $0.2 < $1.2 }
        
        // Track which trucks have been scheduled
        var scheduledTrucks: Set<String> = []
        
        // Process each charging option
        for (truck, charger, timeRequired) in chargingOptions {
            // Skip if truck already scheduled
            if scheduledTrucks.contains(truck.id) {
                continue
            }
            
            // Get when this charger becomes available
            let chargerAvailableAt = chargerAvailability[charger.id] ?? 0.0
            
            // Check if we can complete charging within time window
            if chargerAvailableAt + timeRequired <= timeWindow {
                // Schedule this charging session
                let session = ChargingSession(
                    truck: truck,
                    charger: charger,
                    startTime: chargerAvailableAt,
                    duration: timeRequired
                )
                
                sessions.append(session)
                scheduledTrucks.insert(truck.id)
                
                // Update charger availability
                chargerAvailability[charger.id] = chargerAvailableAt + timeRequired
            }
        }
        
        return ChargingSchedule(sessions: sessions, totalTimeWindow: timeWindow)
    }
}
