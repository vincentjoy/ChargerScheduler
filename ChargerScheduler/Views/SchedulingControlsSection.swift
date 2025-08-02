//
//  SchedulingControlsSection.swift
//  ChargerScheduler
//
//  Created by Vincent Joy on 02/08/25.
//

import SwiftUI

struct SchedulingControlsSection: View {
    @ObservedObject var viewModel: ChargingSchedulerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Scheduling Algorithm")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                
                Picker("Algorithm", selection: $viewModel.selectedAlgorithm) {
                    ForEach(ChargingSchedulerViewModel.SchedulingAlgorithm.allCases) { algorithm in
                        Text(algorithm.rawValue).tag(algorithm)
                    }
                }
                .pickerStyle(.segmented)
                
                Text(viewModel.selectedAlgorithm.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
