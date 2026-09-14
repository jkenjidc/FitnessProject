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
@MainActor
class HealthKitService {
    //This should be private
    var healthStore = HKHealthStore()
    var isHealthDataAvailable = HKHealthStore.isHealthDataAvailable()
    var shouldRequestAuthorization = false

    // MARK: Step Count Data
    var stepCountToday: Int? = nil
    var thisWeekSteps: [Date: Int] = [:]

    // this is the type of data we will be reading from Health (e.g stepCount)
    private let toReads: Set<HKObjectType> = [HKQuantityType(.stepCount)]

    func getAuthRequestStatus() async {
        guard isHealthDataAvailable else { return }
        do {
            let status = try await healthStore.statusForAuthorizationRequest(toShare: [], read: toReads)
            shouldRequestAuthorization = status == .shouldRequest
        } catch {
            Log.error("Accessing authorization status for HealthKit Failed: \(error)")
        }
    }

    func requestAuthorization() async {
        guard isHealthDataAvailable else { return }
        do {
            try await healthStore.requestAuthorization(toShare: [], read: toReads)
            shouldRequestAuthorization = false
            await fetchAllDatas()
        } catch {
            Log.error("Unexpected HealthKit error occured, check usage and share descriptions or device support: \(error)")
        }
    }

    func fetchAllDatas() async {
        await readStepCountToday()
        await readStepCountThisWeek()
    }
}
