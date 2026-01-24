//
//  HealthKitManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/5/25.
//

import Foundation
import HealthKit
import WidgetKit

@Observable
class HealthKitService {
    static let shared = HealthKitService()

    var healthStore = HKHealthStore()

    var stepCountToday: Int? = nil
    var thisWeekSteps: [Date: Int] = [:]
    var stepCountYesterday: Int = 0

    var caloriesBurnedToday: Int = 0

    func requestAuthorization() {
        // this is the type of data we will be reading from Health (e.g stepCount)
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!])

        // this is to make sure User's Heath Data is Available
        guard HKHealthStore.isHealthDataAvailable() else {
            Log.error("health data not available!")
            return
        }

        // asking User's permission for their Health Data
        // note: toShare is set to nil since I'm not updating any data
        healthStore.requestAuthorization(toShare: nil, read: toReads) {
            success, error in
            if success {
                self.fetchAllDatas()
            } else {
                print("\(String(describing: error))")
            }
        }
    }

    func fetchAllDatas() {
        readStepCountToday()
        readStepCountThisWeek()
    }

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
            guard let result = result, let sum = result.sumQuantity() else {
                switch self.healthStore.authorizationStatus(for: stepCountType) {
                case .notDetermined: break
                    //TODO: re - request with just the not determined data type and not all types
                case .sharingDenied:
                    self.stepCountToday = nil
                    Log.error("failed to read step count, user has denied access to data type")
                case .sharingAuthorized:
                    Log.error("failed to read step count but user authorized access to data type")
                @unknown default:
                    Log.error("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                }
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
                Log.error("No result returned from HealthKit query")
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
