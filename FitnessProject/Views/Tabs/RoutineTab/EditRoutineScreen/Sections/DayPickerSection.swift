//
//  DayPickerSection.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

extension EditRoutineScreen {
    struct DayPickerSection: View {
        // TODO: Refactor to use something like a Days enum for type safety
        @Binding var selectedDays: [String]
        @State var selectedDaysBool: [Bool]
        let daysOfTheWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        init(selectedDays: Binding<[String]>) {
            self._selectedDays = selectedDays
            // Map selected days to boolean array
            let mappedBool = daysOfTheWeek.map { day in
                selectedDays.wrappedValue.contains(day)
            }
            self._selectedDaysBool = State(initialValue: mappedBool)
        }

        var body: some View {
            Section(header: Text("Days to do"),
                    footer: Text(footerText)) {
                HStack(spacing: 10){
                    Spacer()
                    ForEach(0..<7, id: \.self){ index in
                        Button {
                            selectDay(index)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(selectedDaysBool[index] ? .green : .secondary)
                                    .opacity(0.5)

                                Text("\(String(daysOfTheWeek[index].first!))")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 38, height: 38)
                        }
                        .buttonStyle(.plain)

                    }
                    Spacer()
                }
            }
                    .listRowBackground(Color(UIColor.systemGroupedBackground))
        }
    }
}

extension EditRoutineScreen.DayPickerSection {
    var footerText: String {
        if selectedDays.count == 7 {
            return "Selected days: Everyday"
        } else if selectedDays == ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]{
            return "Selected days: Weekdays"
        } else if selectedDays == ["Saturday", "Sunday"]{
            return "Selected days: Weekends"
        } else if selectedDays.count == 1 {
            return "Selected day: " + ListFormatter.localizedString(byJoining: selectedDays)
        } else if selectedDays.count > 1 {
            return "Selected days: " + ListFormatter.localizedString(byJoining: selectedDays)
        } else {
            return ""
        }
    }

    // TODO: Refactor this to not use 2 sources of truths
    func selectDay(_ index: Int) {
        if selectedDaysBool[index] {
            selectedDaysBool[index] = false
            let boolIndex = selectedDays.firstIndex(where: { $0 == daysOfTheWeek[index] })!
            selectedDays.remove(at: boolIndex)
        } else {
            selectedDaysBool[index] = true
            selectedDays.append(daysOfTheWeek[index])
        }
    }
}

#Preview {
    @Previewable @State var previewValue = ["Monday"]
    EditRoutineScreen.DayPickerSection(selectedDays: $previewValue)
}
