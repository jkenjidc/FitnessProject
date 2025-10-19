//
//  HealthKitSectionsView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/10/25.
//

import SwiftUI

struct HealthKitSection: View {
    @Environment(HealthKitService.self) var hkManager
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("HEALTH")
                .foregroundStyle(.secondary)
                .bold()
                .font(.headline)
            StepCounterView()
                .environment(hkManager)
        }
        .onAppear {
            hkManager.requestAuthorization()
        }
    }
}

#Preview {
    HealthKitSection()
}
