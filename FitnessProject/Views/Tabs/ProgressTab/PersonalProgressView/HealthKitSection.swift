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
            
            // Show sync button only if authorization hasn't been requested yet
//            if hkManager.shouldShowSyncButton {
                Button {
                    hkManager.requestAuthorization()
                } label: {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Sync to Apple Health")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
//            }
        }
        .onAppear {
            // Check authorization status instead of immediately requesting
            hkManager.getAuthRequestStatus()
        }
    }
}

#Preview {
    HealthKitSection()
}
