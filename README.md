# EV Fleet Charging Scheduler

A Swift iOS app that optimally schedules overnight charging for a fleet of electric mail trucks using a fixed number of chargers within a time window.

## Overview

This app solves the EV charging scheduling problem by implementing a greedy algorithm that maximizes the number of trucks charged to 100% within the given time constraints. The architecture is designed to be modular and extensible, allowing for easy integration of additional scheduling algorithms.

### Problem Statement

- **Goal**: Charge as many trucks to 100% as possible within a fixed time window
- **Constraints**: 
  - Each charger can only charge one truck at a time
  - Trucks must charge continuously until full
  - Limited number of chargers and time window

### Key Features

- **Multiple Scheduling Algorithms**: Greedy time-based and energy-priority algorithms
- **Interactive UI**: SwiftUI interface with real-time schedule visualization
- **Configurable Data**: Easy modification of trucks, chargers, and time parameters
- **Comprehensive Testing**: Unit tests covering core logic and edge cases
- **Clean Architecture**: Protocol-oriented design following MVVM pattern

## How to Use the App

### Main Interface

1. **Fleet Overview**: View the trucks already added in the dummy data file DataSamples.swift
2. **Charger Overview**: View the chargers already added in the dummy data file DataSamples.swift
2. **Set Time**: Preset with the time set in DataSamples.swift file, which can be modified here
3. **Algorithm Selection**: Choose between different scheduling algorithms:
   - **Greedy (Shortest Time First)**: Prioritizes trucks that can be charged fastest
   - **Highest Energy First**: Prioritizes trucks with the highest energy requirements

4. **Generate Schedule**: Click the "Generate Schedule" button to create an optimal charging plan
5. **View Results**: See which trucks are assigned to which chargers and when they charge

## Modifying Input Data

### Code-Based Modifications

To change the default data, modify the static properties in `DataSamples.swift`:

```swift
// Modify truck fleet
static let sampleTrucks: [Truck] = [
    Truck(id: "YourTruck_1", batteryCapacity: 120.0, currentChargeLevel: 25.0),
    // Add more trucks...
]

// Modify charger stations
static let sampleChargers: [Charger] = [
    Charger(id: "YourCharger_1", chargingRate: 75.0),
    // Add more chargers...
]

// Modify time window
static let timeWindow: Double = 10.0 // 10 hours
```

### UI-Based Modifications

Use the "Main App" interface in the app to:
- Remove by swipe or 'Add' button tap to add/remove trucks with custom battery capacity and charge levels
- Remove by swipe or 'Add' button tap to add/remove chargers with custom charging rates
- Adjust the time window using the +/- stepper

## Algorithm Details

### Greedy Time Scheduler (Default)

**Strategy**: Prioritize trucks that require the least charging time

**Process**:
1. Calculate charging time for each truck on each charger
2. Sort all (truck, charger) combinations by charging time (shortest first)
3. Assign trucks to chargers ensuring no conflicts and time constraints
4. Skip trucks that cannot be fully charged within the time window

**Advantages**: Fast execution, good for maximizing the number of trucks charged

### Highest Energy First Scheduler

**Strategy**: Prioritize trucks with the highest energy requirements

**Process**:
1. Sort trucks by energy needed (highest first)
2. For each truck, find the fastest available charger that can complete the job
3. Assign truck to charger if time permits
4. Continue until all trucks are processed or time runs out

**Advantages**: Ensures high-capacity trucks get priority, useful for energy optimization

## Architecture Design

### Protocol-Oriented Approach

The `ChargingScheduler` protocol allows easy plugging in of new algorithms:

```swift
protocol ChargingScheduler {
    func schedule(trucks: [Truck], chargers: [Charger], timeWindow: Double) -> ChargingSchedule
}
```

### MVVM Pattern

- **Model**: `Truck`, `Charger`, `ChargingSchedule` structs
- **View**: SwiftUI views (`ContentView`, `AllocationChartView`, `SchedulingControlsSection`)
- **ViewModel**: `ChargingViewModel` manages state and business logic
