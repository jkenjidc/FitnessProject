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
                    HStack {
                        Text("STREAK CALENDAR")
                            .foregroundStyle(.secondary)
                            .bold()
                            .font(.headline)
                            .padding(.leading, 10)
                        Spacer()
                        if let weekCount = dataManager.user.streakInfo?.weekCount, weekCount > 0 {
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
                                    .underline(viewModel.shouldShowUnderline(day), color: .green)
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
                    .padding(.vertical)

                    if !viewModel.filteredWeightEntries.isEmpty{
                        HStack{
                            Spacer()
                            Chart(viewModel.filteredWeightEntries, id: \.self) { weightEntry in
                                LineMark(x: .value("date", weightEntry.entryDateString) , y: .value("weight", weightEntry.weight))
                                    .symbol{
                                        ZStack{
                                            Image(systemName: "circle.fill")
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .interpolationMethod(.catmullRom)
                                PointMark(x: .value("date", weightEntry.entryDateString), y: .value("weight", weightEntry.weight))
                                    .annotation(position: .top) {
                                        Text(String(format: "%.2f",weightEntry.weight))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                            }
                            .chartOverlay { chartProxy in
                                GeometryReader { geometry in
                                    Rectangle().fill(.clear).contentShape(Rectangle())
                                        .onTapGesture { location in
                                            let relativeLocation = CGPoint(
                                                x: location.x - geometry.frame(in: .local).minX,
                                                y: location.y - geometry.frame(in: .local).minY
                                            )
                                            if let (date, weight):(String, Double) = chartProxy.value(at: relativeLocation){
                                                viewModel.handleChartTap(date: date, weight: weight)
                                            }
                                        }
                                }
                            }
                            .chartYScale(domain: viewModel.weightAxisLowerBound...viewModel.weightAxisUpperBound)
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.vertical, 5)
                            .padding(.trailing, 5)
                            .chartXAxis {
                                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                            }
                            .chartYAxis {
                                AxisMarks(preset: .aligned)
                            }
                            .chartScrollableAxes(.horizontal)
                            .chartXVisibleDomain(length: 5)
                            //filteredWeightEntries is guaranteed to never be empty when showing the chart, force unwrap is ok here
                            .chartScrollPosition(initialX:viewModel.filteredWeightEntries.last!.entryDateString)


                            Spacer()
                        }
                    } else if viewModel.weightEntries.isEmpty {
                        ContentUnavailableView {
                            Image(systemName: "arrow.up.forward")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.secondary)
                        } description: {
                            Text("No Weight Data, add weight entry")
                        }
                        .padding(.top, 25)
                    } else {
                        ContentUnavailableView {
                            Image(systemName: "rectangle.on.rectangle.slash.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.secondary)
                        } description: {
                            Text("No Weight Data for this range, try changing the date range")
                        }
                        .padding(.top, 25)
                    }
                }

                Picker("Date Range Picker", selection: $viewModel.currentDatePickerSelection) {
                    ForEach(DatePickerSelection.allCases, id: \.self) { dateRange in
                        Text(dateRange.rawValue)
                   }
                }
                .pickerStyle(.segmented)
                .padding()
                Spacer()
            }
            .scrollBounceBehavior(.basedOnSize)
            .padding()
            .onAppear {
                viewModel.days = viewModel.date.calendarDisplayDays
                viewModel.weightEntries = dataManager.user.weightHistory ?? []
            }.onChange(of: viewModel.date) {
                viewModel.days = viewModel.date.calendarDisplayDays
            }
            .onDisappear {
                viewModel.date = Date.now
            }
            if viewModel.presentWeightEntryPopup {
                WeightEntryView(presentEntryView: $viewModel.presentWeightEntryPopup, currentWeightEntry: viewModel.currentWeightEntry){ weightEntry, weightEntryAction in
                    viewModel.weightEntryAction(weight: weightEntry, actionType: weightEntryAction)
                }
                .onDisappear {
                    viewModel.currentWeightEntry = nil
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
