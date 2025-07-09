//
//  PersonalProgressView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/24.
//

import SwiftUI
import Charts

struct PersonalProgressView: View {
    @Environment(Router.self) var router
    @Environment(HealthKitManager.self) var hkManager
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(weekCount: dataManager.user.streakInfo?.weekCount)

                CalendarView()

                WeightChart()

                VStack(alignment: .leading, spacing: 15) {
                    Text("HEALTH")
                        .foregroundStyle(.secondary)
                        .bold()
                        .font(.headline)
                    StepCounterView()
                        .environment(hkManager)
                }
                .onAppear {
                    hkManager.requestAuthorization()
                }
                Spacer()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .padding()
    }
}

private extension PersonalProgressView {
    struct HeaderView: View {
        @Environment(Router.self) var router
        let weekCount: Int?
        var body: some View {
            HStack {
                Text("STREAK CALENDAR")
                    .title()
                Spacer()
                if let weekCount {
                    Button {
                        router.presentSheet(.streakInfo)
                    } label: {
                        Label{
                            Text(AttributedString.formattedWeeks(weekCount))
                        } icon: {
                            Image(systemName: "flame.circle.fill")
                        }
                        .foregroundStyle(.orange)
                        .padding(.trailing, 10)
                    }
                }
            }
        }

    }
}


#Preview {
    PersonalProgressView()
        .environment(Router())
        .environment(HealthKitManager())
        .preferredColorScheme(.dark)
}
