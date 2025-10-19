//
//  HKWeeklyStepsCover.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 6/16/25.
//
import Charts
import SwiftUI


struct HKWeeklyStepsCover: View {
    @Environment(HealthKitService.self) var hkManager
    @Environment(Router.self) var router
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            BackButton(navigationMode: .fullScreenCover)
            Text("Weekly Steps")
                .title()
            Chart {
                ForEach(hkManager.thisWeekSteps.keys.sorted(), id: \.self) { key in
                    BarMark(
                        x: .value("date",key.weekdayString),
                        y: .value("steps", hkManager.thisWeekSteps[key] ?? 0)
                    )
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .chartYAxis {
                AxisMarks(preset: .aligned)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HKWeeklyStepsCover()
        .environment(HealthKitService())
        .environment(Router())
}
