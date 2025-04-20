//
//  StreakInfoSheet.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/20/25.
//

import SwiftUI

struct StreakInfoSheet: View {
    let weeks = 2
    let averageWorkout = 2.1
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "flame.fill")
                .resizable()
                .frame(width: 200, height: 250)
                .foregroundStyle(.orange)
            Text(AttributedString.formattedWeeks(weeks, "streak"))
                .fontWeight(.bold)
                .font(.system(size: 30))
                .foregroundStyle(.orange)
            Text(AttributedString.styledWorkoutSummary(averageWorkout, weeks))
                .font(.system(size: 40))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(20)
        .presentationDragIndicator(.visible)
    }
}

extension AttributedString {
    static func formattedWeeks(_ weeks: Int, _ label: String? = nil) -> String {
        return "\(weeks) \(weeks == 1 ? "week" : "weeks") \(label ?? "")"
    }
    static func styledWorkoutSummary(_ workoutCount: Double, _ weeks: Int) -> AttributedString {
        // Format workout count to only show decimal if needed
        let formattedCount = workoutCount.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", workoutCount)
            : String(format: "%.1f", workoutCount)

        // Format duration with proper pluralization
        let durationText = self.formattedWeeks(weeks)

        let baseString = "Great Job! You've done an average of \(formattedCount) workouts per day for \(durationText), Keep up the good work!"
        var attributedString = AttributedString(baseString)

        // Style for workout count
        if let countRange = attributedString.range(of: formattedCount) {
            attributedString[countRange].foregroundColor = .orange
            attributedString[countRange].font = .boldSystemFont(ofSize: 40)
        }

        // Style for duration
        if let durationRange = attributedString.range(of: durationText) {
            attributedString[durationRange].foregroundColor = .orange
            attributedString[durationRange].font = .boldSystemFont(ofSize: 40)
        }

        return attributedString
    }
}

#Preview {
    StreakInfoSheet()
        .preferredColorScheme(.dark)
}
