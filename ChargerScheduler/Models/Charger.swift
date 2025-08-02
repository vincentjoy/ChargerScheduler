//
//  Charger.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import Foundation

struct Charger: Identifiable, Hashable {
    let id: String
    let chargingRate: Double // in kW
    
    init(id: String, chargingRate: Double) {
        self.id = id
        self.chargingRate = max(chargingRate, 0) // Ensure non-negative
    }
}
