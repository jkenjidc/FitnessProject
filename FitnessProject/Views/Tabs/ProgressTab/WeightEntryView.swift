//
//  WeightEntryView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/8/25.
//

import SwiftUI

struct WeightEntryView: View {
    @Environment(Router.self) var router
    @GestureState var pressed = false
    @State var selectedDate: Date = Date.now
    @State var currentWeight: Double = 0.0
    var currentWeightEntry: WeightEntry?
    var weightString: String {
        currentWeightEntry != nil ? "Update" : "Add"
    }

    var actionType: WeightEntryAction {
        currentWeightEntry != nil ? .update : .create
    }
    let action: ((WeightEntry, WeightEntryAction) -> Void)

    init(viewModel: WeightChart.ViewModel){
        self.action = viewModel.weightEntryAction
        if let unwrappedWeightEntry = viewModel.currentWeightEntry {
            _selectedDate = State(initialValue: unwrappedWeightEntry.entryDate)
            _currentWeight = State(initialValue: unwrappedWeightEntry.weight)
        }
        self.currentWeightEntry = viewModel.currentWeightEntry
    }
    var body: some View {
        VStack{
            Text("\(weightString) Weight Entry")
                .font(.title2)
                .bold()
                .padding()
                .foregroundStyle(.white)

            HStack {
                EntryFieldView(
                    valueBinding: $currentWeight,
                    placeholderString: "Enter Weight",
                    keyboardType: .numeric
                )

                DatePicker("", selection: $selectedDate,in: ...Date.now , displayedComponents: [.date])
                    .foregroundStyle(.white)
                    .colorScheme(.dark)
                    .buttonStyle(.plain)
            }

            Button {
                handleAction(actionType: actionType)
            } label: {
                Text("\(weightString) Weight")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.accentColor.opacity(0.6))
                    .cornerRadius(20)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.top)
            .disabled(currentWeight > 400 )

            if currentWeightEntry != nil {
                LongPressButton {
                    handleAction(actionType: .delete)
                }
                .padding(.horizontal)
            }
        }
    }

    func handleAction(actionType: WeightEntryAction) {
        router.dismissModal()
        var weightEntry = currentWeightEntry ?? WeightEntry(weight: currentWeight, entryDate: selectedDate)
        switch actionType {
        case .create:
            self.action(weightEntry, .create)
        case .update:
            weightEntry.weight = currentWeight
            weightEntry.entryDate = selectedDate
            self.action(weightEntry, .update)
        case .delete:
            self.action(weightEntry, .delete)
        }

    }
}

public enum WeightEntryAction {
    case create
    case update
    case delete
}


#Preview {
    WeightEntryView(viewModel: WeightChart.ViewModel())
    .preferredColorScheme(.dark)
}
