//
//  ChargerSchedulerTests.swift
//  ChargerSchedulerTests
//
//  Created by Vincent Joy on 02/08/25.
//

import XCTest
@testable import ChargerScheduler

final class ChargerSchedulerTests: XCTestCase {
    
    var trucks: [Truck]!
    var chargers: [Charger]!
    var greedyScheduler: GreedyTimeScheduler!

    override func setUpWithError() throws {
        super.setUp()
        
        // Test data setup
        trucks = [
            Truck(id: "T1", batteryCapacity: 100.0, currentChargeLevel: 50.0), // 50 kWh needed
            Truck(id: "T2", batteryCapacity: 200.0, currentChargeLevel: 25.0), // 150 kWh needed
            Truck(id: "T3", batteryCapacity: 80.0, currentChargeLevel: 75.0),  // 20 kWh needed
            Truck(id: "T4", batteryCapacity: 150.0, currentChargeLevel: 10.0), // 135 kWh needed
        ]
        
        chargers = [
            Charger(id: "C1", chargingRate: 50.0), // 50 kW
            Charger(id: "C2", chargingRate: 100.0), // 100 kW
        ]
        
        greedyScheduler = GreedyTimeScheduler()
    }

    override func tearDownWithError() throws {
        trucks = nil
        chargers = nil
        greedyScheduler = nil
        super.tearDown()
    }

    // MARK: - Model Tests
    
    func testTruckEnergyCalculation() throws {
        let truck = Truck(id: "Test", batteryCapacity: 100.0, currentChargeLevel: 30.0)
        
        XCTAssertEqual(truck.energyNeededToFull, 70.0)
        XCTAssertFalse(truck.isFullyCharged)
    }
    
    func testTruckFullyCharged() throws {
        let truck = Truck(id: "Test", batteryCapacity: 100.0, currentChargeLevel: 100.0)
        
        XCTAssertEqual(truck.energyNeededToFull, 0.0)
        XCTAssertTrue(truck.isFullyCharged)
        XCTAssertNil(truck.timeToFullCharge(using: chargers[0]))
    }
    
    func testTruckChargingTimeCalculation() throws {
        let truck = Truck(id: "Test", batteryCapacity: 100.0, currentChargeLevel: 50.0)
        let charger = Charger(id: "Test", chargingRate: 50.0)
        
        let chargingTime = truck.timeToFullCharge(using: charger)
        XCTAssertNotNil(chargingTime)
        XCTAssertEqual(chargingTime!, 1.0) // 50 kWh / 50 kW = 1 hour
    }
    
    func testTruckInputValidation() throws {
        // Test charge level clamping
        let truck1 = Truck(id: "Test1", batteryCapacity: 100.0, currentChargeLevel: -10.0)
        XCTAssertEqual(truck1.currentChargeLevel, 0.0)
        
        let truck2 = Truck(id: "Test2", batteryCapacity: 100.0, currentChargeLevel: 110.0)
        XCTAssertEqual(truck2.currentChargeLevel, 100.0)
    }
    
    func testChargerInputValidation() throws {
        let charger = Charger(id: "Test", chargingRate: -50.0)
        XCTAssertEqual(charger.chargingRate, 0.0)
    }

}
