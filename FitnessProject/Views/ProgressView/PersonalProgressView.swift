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
        ScrollView{
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
                Text("BODY WEIGHT")
                    .foregroundStyle(.secondary)
                    .bold()
                    .font(.headline)
                    .padding(.leading, 10)
                    .padding(.top)
                let weightEntries = [WeightEntry(weight: 156.0),
                                     WeightEntry(weight: 165.4, entryDate: Calendar.current.date(byAdding: .month, value: 1, to: Date.now)!),
                                     WeightEntry(weight: 177.3, entryDate: Calendar.current.date(byAdding: .month, value: 2, to: Date.now)!),
                                     WeightEntry(weight: 170.5, entryDate: Calendar.current.date(byAdding: .month, value: 3, to: Date.now)!),
                                     WeightEntry(weight: 170.5, entryDate: Calendar.current.date(byAdding: .month, value: 4, to: Date.now)!)]
                HStack{
                    Spacer()
                    Chart(weightEntries, id: \.self) { weightEntry in
                        LineMark(x: .value("date", weightEntry.entryDate) , y: .value("weight", weightEntry.weight))
                            .symbol{
                                ZStack{
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 10))
                                }
                            }
                        PointMark(x: .value("date", weightEntry.entryDate), y: .value("weight", weightEntry.weight))
                            .annotation(position: .bottom) {
                                Text(String(weightEntry.weight))
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
                
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.days = viewModel.date.calendarDisplayDays
            }.onChange(of: viewModel.date) {
                viewModel.days = viewModel.date.calendarDisplayDays
            }
            .onDisappear {
                viewModel.date = Date.now
            }
        }
    }
}

#Preview {
    PersonalProgressView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
