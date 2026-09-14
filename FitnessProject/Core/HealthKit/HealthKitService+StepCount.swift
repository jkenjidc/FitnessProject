//
//  HealthKitService+StepCount.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/25/26.
//

import Foundation
import HealthKit

extension HealthKitService {
    func readStepCountToday() async {
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )

        let descriptor = HKStatisticsQueryDescriptor(
            predicate: .quantitySample(type: HKQuantityType(.stepCount), predicate: predicate),
            options: .cumulativeSum
        )

        do {
            let statistics = try await descriptor.result(for: healthStore)

            // sumQuantity is nil if no steps are recorded or the user denied read access
            guard let sum = statistics?.sumQuantity() else {
                // No steps recorded - this is normal, set to 0
                stepCountToday = 0
                return
            }

            stepCountToday = Int(sum.doubleValue(for: .count()))
        } catch {
            Log.error("HealthKit query error: \(error.localizedDescription)")
        }
    }

    func readStepCountThisWeek() async {
        let calendar = Calendar.current
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)

        // Get the start of the week (Sunday or Monday depending on locale)
        guard let startOfWeek = calendar.date(byAdding: .day, value: -7, to: today) else {
            Log.error("Failed to calculate the start date of the week")
            return
        }

        // Use today as the end date to include today's data
        let endDate = startOfToday

        Log.info("Querying step count from \(startOfWeek) to \(endDate)")

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: endDate,
            options: .strictStartDate
        )

        let descriptor = HKStatisticsCollectionQueryDescriptor(
            predicate: .quantitySample(type: HKQuantityType(.stepCount), predicate: predicate),
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )

        do {
            let collection = try await descriptor.result(for: healthStore)

            // Collect locally so the observable property is written once rather than per day
            var steps: [Date: Int] = [:]
            collection.enumerateStatistics(from: startOfWeek, to: endDate) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    steps[statistics.startDate] = Int(quantity.doubleValue(for: .count()))
                }
            }

            thisWeekSteps = steps
            Log.info("Final weekly steps data: \(thisWeekSteps)")
        } catch {
            Log.error("HealthKit query error: \(error.localizedDescription)")
        }
    }
}
