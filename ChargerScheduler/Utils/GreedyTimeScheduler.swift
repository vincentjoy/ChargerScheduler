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
        
        var chargerQueue = chargers.map { ChargerAvailability(charger: $0, availableAt: 0.0) }
        chargerQueue.sort()
        
        var sessions: [ChargingSession] = []
        
        // Sort trucks by energy needed (Greedy: least energy first)
        let sortedTrucks = trucksNeedingCharge.sorted { $0.energyNeededToFull < $1.energyNeededToFull }
        
        for truck in sortedTrucks {
            
            // Find the best available charger for this truck
            var bestOption: (index: Int, startTime: Double, duration: Double)?
            var earliestCompletion = Double.infinity
            
            for  (index, chargerAvailability) in chargerQueue.enumerated() {
                guard let timeRequired = truck.timeToFullCharge(using: chargerAvailability.charger) else { continue }
                
                let completionTime = chargerAvailability.availableAt + timeRequired
                
                // Early termination: if this charger (earliest available) can't fit, later ones won't either
                if chargerAvailability.availableAt >= timeWindow {
                    break
                }
                
                if completionTime <= timeWindow && completionTime < earliestCompletion {
                    earliestCompletion = completionTime
                    bestOption = (index, chargerAvailability.availableAt, timeRequired)
                    
                    // Early termination: if we found a charger available now, use it
                    if chargerAvailability.availableAt == 0 {
                        break
                    }
                }
            }
            
            if let bestOption {
                let chargerAvailability = chargerQueue[bestOption.index]
                let session = ChargingSession(
                    truck: truck,
                    charger: chargerAvailability.charger,
                    startTime: bestOption.startTime,
                    duration: bestOption.duration
                )
                
                sessions.append(session)
                chargerQueue[bestOption.index].availableAt = bestOption.startTime + bestOption.duration
                
                // Re-position this charger in the queue (bubble sort style for single element)
                var updatedIndex = bestOption.index
                while (updatedIndex < chargerQueue.count - 1) && (chargerQueue[updatedIndex] > chargerQueue[updatedIndex+1]) {
                    chargerQueue.swapAt(updatedIndex, updatedIndex+1)
                    updatedIndex += 1  // Move to the next position after swapping
                }
            }
        }
        
        return ChargingSchedule(sessions: sessions, totalTimeWindow: timeWindow)
    }
}
