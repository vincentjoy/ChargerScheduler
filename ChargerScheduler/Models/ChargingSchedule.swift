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
    
    var sessionsByCharger: [String: [Truck]] {
        var result: [String: [Truck]] = [:]
        
        for session in sessions {
            result[session.charger.id, default: []].append(session.truck)
        }
        
        return result
    }
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
