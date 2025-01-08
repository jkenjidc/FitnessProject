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
    @State private var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        ZStack{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 0) {
                    Text("STREAK CALENDAR")
                        .foregroundStyle(.secondary)
                        .bold()
                        .font(.headline)
                        .padding(.leading, 10)
                    LabeledContent("\(viewModel.monthYearText)") {
                        HStack(spacing: 10) {
                            Button {
                                viewModel.adjustMonthByAmount(value: -1)
                            }label: {
                                Image(systemName: "chevron.left")
                                
                            }
                            Button {
                                viewModel.adjustMonthByAmount(value: 1)
                            }label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .fontWeight(.heavy)
                        .buttonStyle(.plain)
                    }
                    .padding()
                    
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
                    HStack{
                        Text("BODY WEIGHT")
                            .foregroundStyle(.secondary)
                            .bold()
                            .font(.headline)
                            .padding(.leading, 10)
                        Spacer()
                        Button {
                            viewModel.presentWeightEntryPopup.toggle()
                        } label: {
                            Label("add entry",systemImage: "plus")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top)
                    HStack{
                        Spacer()
                        Chart(viewModel.weightEntries, id: \.self) { weightEntry in
                            LineMark(x: .value("date", weightEntry.entryDateString) , y: .value("weight", weightEntry.weight))
                                .symbol{
                                    ZStack{
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 10))
                                    }
                                }
                            PointMark(x: .value("date", weightEntry.entryDateString), y: .value("weight", weightEntry.weight))
                                .annotation(position: .bottom) {
                                    Text(String(format: "%.2f",weightEntry.weight))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            
                        }
                        .chartYScale(domain: 120...220)
                        .aspectRatio(1, contentMode: .fill)
                        .padding(5)
                        .chartXAxis {
                            AxisMarks(preset: .aligned)
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.days = viewModel.date.calendarDisplayDays
                WeightEntry.sampleWeightEntryList.forEach { weight in
                    viewModel.addWeightEntry(weight: weight)
                }
            }.onChange(of: viewModel.date) {
                viewModel.days = viewModel.date.calendarDisplayDays
            }
            .onDisappear {
                viewModel.date = Date.now
            }
            if viewModel.presentWeightEntryPopup {
                WeightEntryView(presentEntryView: $viewModel.presentWeightEntryPopup, selectedDate: $viewModel.selectedDate, currentWeight: $viewModel.currentWeight){
                    viewModel.addWeightEntry()
                }
            }
        }
    }
}

#Preview {
    PersonalProgressView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
