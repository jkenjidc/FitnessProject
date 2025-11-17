//
//  PersonalProgressView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/24.
//

import SwiftUI
import Charts

struct PersonalProgressScreen: View {
    @Environment(Router.self) var router
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(weekCount: dataManager.user.streakInfo?.weekCount)

                CalendarView()

                WeightChart()

                HealthKitSection()

                Spacer()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(router.currentTab.rawValue.capitalized)
        .toolbar { profileButtonToolbarItem }
    }
}

private extension PersonalProgressScreen {
    @ToolbarContentBuilder
    var profileButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                router.push(destination: .profileScreen)
            } label: {
                Label("Profile", systemImage: "person")
            }
            .buttonStyle(.plain)
        }
    }

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
    PersonalProgressScreen()
        .environment(Router())
        .environment(HealthKitService())
        .preferredColorScheme(.dark)
}
