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
    //This should be private
    var healthStore = HKHealthStore()
    var isHealthDataAvailable = HKHealthStore.isHealthDataAvailable()
    var shouldRequestAuthorization = false

    // MARK: Step Count Data
    var stepCountToday: Int? = nil
    var thisWeekSteps: [Date: Int] = [:]

    // this is the type of data we will be reading from Health (e.g stepCount)
    private let toReads = Set([
        HKObjectType.quantityType(forIdentifier: .stepCount)!])

    func getAuthRequestStatus() {
        healthStore.getRequestStatusForAuthorization(toShare: Set(), read: toReads) { status, error in
            if let error = error {
                Log.error("Accessing authorization status for HealthKit Failed: \(error)")
                return
            }

            self.shouldRequestAuthorization = status == .shouldRequest
        }
    }

    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: nil, read: self.toReads) {
            success, error in
            if success {
                self.fetchAllDatas()
            } else {
                Log.error("Unexpected HealthKit error occured, check usage and share descriptions or device support")
            }
        }
    }

    func fetchAllDatas() {
        readStepCountToday()
        readStepCountThisWeek()
    }
}
