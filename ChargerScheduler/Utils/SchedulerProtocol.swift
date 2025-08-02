//
//  SchedulerProtocol.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

protocol ChargingScheduler {
    func schedule(trucks: [Truck], chargers: [Charger], timeWindow: Double) -> ChargingSchedule
}
