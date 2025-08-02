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
        
        var chargerAvailability: [String: Double] = [:]
        for charger in chargers {
            chargerAvailability[charger.id] = 0.0
        }
        
        var sessions: [ChargingSession] = []
        
        // Sort trucks by energy needed (highest first)
        let sortedTrucks = trucksNeedingCharge.sorted { $0.energyNeededToFull > $1.energyNeededToFull }
        
        for truck in sortedTrucks {
            // Find the best charger for this truck (fastest that can complete the job)
            var bestOption: (Charger, Double, Double)? = nil // (charger, startTime, duration)
            
            for charger in chargers {
                if let timeRequired = truck.timeToFullCharge(using: charger) {
                    let chargerAvailableAt = chargerAvailability[charger.id] ?? 0.0
                    
                    if chargerAvailableAt + timeRequired <= timeWindow {
                        if bestOption == nil || timeRequired < bestOption!.2 {
                            bestOption = (charger, chargerAvailableAt, timeRequired)
                        }
                    }
                }
            }
            
            // Schedule with best option if found
            if let (charger, startTime, duration) = bestOption {
                let session = ChargingSession(
                    truck: truck,
                    charger: charger,
                    startTime: startTime,
                    duration: duration
                )
                
                sessions.append(session)
                chargerAvailability[charger.id] = startTime + duration
            }
        }
        
        return ChargingSchedule(sessions: sessions, totalTimeWindow: timeWindow)
    }
}
