//
//  TruckConfigRow.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct TruckConfigRow: View {
    let truck: Truck
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(truck.id)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(Int(truck.batteryCapacity)) kWh capacity")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(truck.currentChargeLevel))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(truck.isFullyCharged ? .green : .orange)
                
                Text("charged")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
