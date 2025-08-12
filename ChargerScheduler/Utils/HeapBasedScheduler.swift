//
//  HeapBasedScheduler.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 11/08/25.
//

import Foundation

/**
 Heap based approach to schedule most number of trucks for charging
 */
class HeapBasedScheduler: ChargingScheduler {
    
    func schedule(trucks: [Truck], chargers: [Charger], timeWindow: Double) -> ChargingSchedule {
        let trucksNeedingCharge = trucks.filter { !$0.isFullyCharged }
        
        var heap = MinHeap<ChargerAvailability>()
        for charger in chargers {
            heap.insert(ChargerAvailability(charger: charger, availableAt: 0))
        }
        
        var sessions: [ChargingSession] = []
        let sortedTrucks = trucksNeedingCharge.sorted { $0.energyNeededToFull < $1.energyNeededToFull }
        
        for truck in sortedTrucks {
            guard let earliestCharger = heap.extractMin(),
                  let timeRequired = truck.timeToFullCharge(using: earliestCharger.charger)
            else {
                continue
            }
            
            let completionTime = earliestCharger.availableAt + timeRequired
            
            if completionTime <= timeWindow {
                let session = ChargingSession(
                    truck: truck,
                    charger: earliestCharger.charger,
                    startTime: earliestCharger.availableAt,
                    duration: timeRequired
                )
                sessions.append(session)
                
                // Update and re-insert charger
                let updateCharger = ChargerAvailability(charger: earliestCharger.charger, availableAt: completionTime)
                heap.insert(updateCharger)
            } else {
                // Put the charger back and stop (no more trucks can be scheduled)
                heap.insert(earliestCharger)
                break
            }
        }
        
        return ChargingSchedule(sessions: sessions, totalTimeWindow: timeWindow)
    }
}
