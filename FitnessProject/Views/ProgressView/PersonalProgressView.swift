//
//  PersonalProgressView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/24.
//

import SwiftUI

struct PersonalProgressView: View {
    @Environment(Router.self) var router
    @State private var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        VStack {
            LabeledContent("Calendar Color") {
                ColorPicker("", selection: $viewModel.color, supportsOpacity: false)
            }
            
            LabeledContent("Date/Time") {
                DatePicker("", selection: $viewModel.date)
            }
            
            HStack {
                ForEach(viewModel.daysOfWeek.indices, id: \.self){ index in
                    Text(viewModel.daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(viewModel.color)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: viewModel.columns){
                ForEach(viewModel.days, id: \.self){ day in
                    if day.monthInt != viewModel.date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle( viewModel.getDayColor(day: day, routineHistory: dataManager.user.routineHistory ?? nil))
                            )
                    }
                    
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.days = viewModel.date.calendarDisplayDays
        }.onChange(of: viewModel.date) {
            viewModel.days = viewModel.date.calendarDisplayDays
        }
    }
}

#Preview {
    PersonalProgressView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
