//
//  HighestEnergyFirstScheduler.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

/**
 Scheduling algorithm that prioritizes trucks with highest energy needs
 */
class HighestEnergyFirstScheduler: ChargingScheduler {
    
    func schedule(trucks: [Truck], chargers: [Charger], timeWindow: Double) -> ChargingSchedule {
        let trucksNeedingCharge = trucks.filter { !$0.isFullyCharged }
        
        // Pre-sort chargers by charging rate (fastest first)
        let sortedChargers = chargers.sorted { $0.chargingRate > $1.chargingRate }
        
        var chargerAvailability: [String: Double] = [:]
        for charger in sortedChargers {
            chargerAvailability[charger.id] = 0.0
        }
        
        var sessions: [ChargingSession] = []
        
        // Sort trucks by energy needed (highest first)
        let sortedTrucks = trucksNeedingCharge.sorted { $0.energyNeededToFull > $1.energyNeededToFull }
        
        for truck in sortedTrucks {
            // Find first available charger that can complete the job
            for charger in sortedChargers {
                if let timeRequired = truck.timeToFullCharge(using: charger) {
                    let chargerAvailableAt = chargerAvailability[charger.id] ?? 0.0
                    
                    if chargerAvailableAt + timeRequired <= timeWindow {
                        let session = ChargingSession(
                            truck: truck,
                            charger: charger,
                            startTime: chargerAvailableAt,
                            duration: timeRequired
                        )
                        
                        sessions.append(session)
                        chargerAvailability[charger.id] = chargerAvailableAt + timeRequired
                        break // Take the first (fastest) available charger
                    }
                }
            }
        }
        
        return ChargingSchedule(sessions: sessions, totalTimeWindow: timeWindow)
    }
}
