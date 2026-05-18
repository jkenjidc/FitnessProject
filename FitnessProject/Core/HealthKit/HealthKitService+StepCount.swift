//
//  HealthKitService+StepCount.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/25/26.
//

import Foundation
import HealthKit

extension HealthKitService {
    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            // Check for actual errors first
            if let error = error {
                Log.error("HealthKit query error: \(error.localizedDescription)")
                return
            }

            // Check if sumQuantity exists (could be nil if no steps recorded or user has denied permission to read this data)
            guard let sum = result?.sumQuantity() else {
                // No steps recorded - this is normal, set to 0
                self.stepCountToday = 0
                return
            }

            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCountToday = steps
        }
        healthStore.execute(query)
    }

    func readStepCountThisWeek() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            Log.error("Failed to create step count type")
            return
        }

        let calendar = Calendar.current
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)

        // Get the start of the week (Sunday or Monday depending on locale)
        guard let startOfWeek = calendar.date(byAdding: .day,value: -7, to: today) else {
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

        let query = HKStatisticsCollectionQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )

        query.initialResultsHandler = { [weak self] _, result, error in
            guard let self = self else { return }

            if let error = error {
                Log.error("HealthKit query error: \(error.localizedDescription)")
                return
            }

            guard let result = result else {
                Log.info("No result returned from HealthKit query")
                return
            }


            result.enumerateStatistics(from: startOfWeek, to: endDate) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    self.thisWeekSteps[statistics.startDate] = steps
                }
            }

            Log.info("Final weekly steps data: \(self.thisWeekSteps)")
        }

        healthStore.execute(query)
    }
}
