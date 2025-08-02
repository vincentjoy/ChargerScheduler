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
        let trucksNeedingCharge = trucks.filter { !$0.isFullyCharged }
        
        var chargerAvailability: [String: Double] = [:]
        for charger in chargers {
            chargerAvailability[charger.id] = 0.0
        }
        
        var sessions: [ChargingSession] = []
        var scheduledTrucks: Set<String> = []
        
        // Sort trucks by energy needed (least energy first for quicker wins)
        let sortedTrucks = trucksNeedingCharge.sorted { $0.energyNeededToFull < $1.energyNeededToFull }
        
        for truck in sortedTrucks {
            if scheduledTrucks.contains(truck.id) { continue }
            
            // Find the best available charger for this truck
            var bestOption: (charger: Charger, startTime: Double, duration: Double)?
            var earliestCompletion = Double.infinity
            
            for charger in chargers {
                guard let timeRequired = truck.timeToFullCharge(using: charger) else { continue }
                
                let chargerAvailableAt = chargerAvailability[charger.id] ?? 0.0
                let completionTime = chargerAvailableAt + timeRequired
                
                if completionTime <= timeWindow && completionTime < earliestCompletion {
                    earliestCompletion = completionTime
                    bestOption = (charger, chargerAvailableAt, timeRequired)
                }
            }
            
            if let option = bestOption {
                let session = ChargingSession(
                    truck: truck,
                    charger: option.charger,
                    startTime: option.startTime,
                    duration: option.duration
                )
                
                sessions.append(session)
                scheduledTrucks.insert(truck.id)
                chargerAvailability[option.charger.id] = option.startTime + option.duration
            }
        }
        
        return ChargingSchedule(sessions: sessions, totalTimeWindow: timeWindow)
    }
}
