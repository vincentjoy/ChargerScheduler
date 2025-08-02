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
        return ChargingSchedule(sessions: [], totalTimeWindow: 0)
    }
}
