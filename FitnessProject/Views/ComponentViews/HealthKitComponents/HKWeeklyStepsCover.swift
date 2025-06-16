//
//  HKWeeklyStepsCover.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 6/16/25.
//
import Charts
import SwiftUI


struct HKWeeklyStepsCover: View {
    @Environment(HealthKitManager.self) var hkManager
    @Environment(Router.self) var router
    var body: some View {
        Button("close"){
            router.dismissCover()
        }
        ForEach(hkManager.thisWeekSteps.keys.sorted(), id: \.self) { key in
            Text("\(key): \(hkManager.thisWeekSteps[key] ?? 0)")
        }
    }
}

#Preview {
    HKWeeklyStepsCover()
        .environment(HealthKitManager())
}
