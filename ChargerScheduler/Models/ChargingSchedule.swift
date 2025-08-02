//
//  ChargingSchedule.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

struct ChargingSchedule {
    let sessions: [ChargingSession]
    let totalTimeWindow: Double
}

struct ChargingSession {
    let truck: Truck
    let charger: Charger
    let startTime: Double // hours from start
    let duration: Double // hours
    
    var endTime: Double {
        return startTime + duration
    }
}
