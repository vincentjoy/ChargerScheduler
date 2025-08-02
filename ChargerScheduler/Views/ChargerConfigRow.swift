//
//  ChargerConfigRow.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct ChargerConfigRow: View {
    let charger: Charger
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(charger.id)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("DC Fast Charger")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(charger.chargingRate)) kW")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text("charging rate")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
