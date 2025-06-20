//
//  StepCounterView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 6/16/25.
//

import SwiftUI

struct StepCounterView: View {
    @Environment(HealthKitManager.self) var hkManager
    @Environment(Router.self) var router
    var body: some View {
        Button {
            router.presentFullScreenCover(.weeklyStepView)
        } label: {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    if let stepCount = hkManager.stepCountToday {
                        Text("Steps")
                        Text("\(stepCount)")
                    } else {
                        Text("Change Permissions in\nthe Health app to view")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                Image(systemName: hkManager.stepCountToday != nil ? "figure.walk" : "heart.slash.fill")
                    .resizable()
                    .frame(width: hkManager.stepCountToday != nil ? 20 : 30, height: 30)
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .buttonStyle(.plain)
        .disabled(hkManager.stepCountToday == nil)
    }
}

#Preview {
    StepCounterView()
        .environment(HealthKitManager())
        .environment(Router())
        .preferredColorScheme(.dark)
}
