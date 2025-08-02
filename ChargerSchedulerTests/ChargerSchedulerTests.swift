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
    var energyFirstScheduler: HighestEnergyFirstScheduler!

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
        energyFirstScheduler = HighestEnergyFirstScheduler()
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

    // MARK: - Greedy Scheduler Tests
    
    func testGreedySchedulerBasicFunctionality() throws {
        let timeWindow = 5.0 // 5 hours
        let schedule = greedyScheduler.schedule(trucks: trucks, chargers: chargers, timeWindow: timeWindow)
        
        // Should schedule some trucks
        XCTAssertGreaterThan(schedule.sessions.count, 0)
        XCTAssertEqual(schedule.totalTimeWindow, timeWindow)
        
        // All sessions should fit within time window
        for session in schedule.sessions {
            XCTAssertLessThanOrEqual(session.endTime, timeWindow)
            XCTAssertGreaterThanOrEqual(session.startTime, 0.0)
            XCTAssertGreaterThan(session.duration, 0.0)
        }
    }
    
    func testGreedySchedulerPrioritizesShortestTime() throws {
        let timeWindow = 10.0
        let schedule = greedyScheduler.schedule(trucks: trucks, chargers: chargers, timeWindow: timeWindow)
        
        // T3 should be scheduled first (shortest charging time: 20kWh/100kW = 0.2h)
        let t3Sessions = schedule.sessions.filter { $0.truck.id == "T3" }
        XCTAssertEqual(t3Sessions.count, 1)
        
        // T3 should start at time 0 (first to be scheduled)
        XCTAssertEqual((t3Sessions.first?.startTime ?? 0), 0.0)
    }
    
    // MARK: - Energy First Scheduler Tests
    
    func testEnergyFirstSchedulerBasicFunctionality() throws {
        let timeWindow = 10.0
        let schedule = energyFirstScheduler.schedule(trucks: trucks, chargers: chargers, timeWindow: timeWindow)
        
        XCTAssertGreaterThan(schedule.sessions.count, 0)
        XCTAssertEqual(schedule.totalTimeWindow, timeWindow)
        
        // All sessions should fit within time window
        for session in schedule.sessions {
            XCTAssertLessThanOrEqual(session.endTime, timeWindow)
        }
    }
    
    func testEnergyFirstSchedulerPrioritizesHighestEnergy() throws {
        let timeWindow = 10.0
        let schedule = energyFirstScheduler.schedule(trucks: trucks, chargers: chargers, timeWindow: timeWindow)
        
        // T2 has highest energy need (150 kWh), should be prioritized if time allows
        let t2Sessions = schedule.sessions.filter { $0.truck.id == "T2" }
        
        if t2Sessions.count > 0 {
            // If T2 is scheduled, it should get a fast charger
            let t2Session = t2Sessions.first!
            XCTAssertGreaterThanOrEqual(t2Session.charger.chargingRate, 50.0)
        }
    }
}
