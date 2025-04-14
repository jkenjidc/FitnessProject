//
//  WeightEntryView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/8/25.
//

import SwiftUI

struct WeightEntryView: View {
    @GestureState var pressed = false
    @Binding var presentEntryView: Bool
    @State private var scale = 0.0
    @State var selectedDate: Date = Date.now
    @State var currentWeight: String = ""
    var currentWeightEntry: WeightEntry?
    var weightString: String {
        currentWeightEntry != nil ? "Update" : "Add"
    }
    
    var actionType: WeightEntryAction {
        currentWeightEntry != nil ? .update : .create
    }
    
    let action: ((WeightEntry, WeightEntryAction) -> Void)
    
    init(presentEntryView: Binding<Bool>, currentWeightEntry: WeightEntry?, action: @escaping (WeightEntry,WeightEntryAction) -> Void){
        _presentEntryView = presentEntryView
        self.action = action
        if let unwrappedWeightEntry = currentWeightEntry {
            _selectedDate = State(initialValue: unwrappedWeightEntry.entryDate)
            _currentWeight = State(initialValue: String(unwrappedWeightEntry.weight))
        }
        self.currentWeightEntry = currentWeightEntry
    }
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.2)
                .onTapGesture {
                    close()
                }
            VStack{
                Text("\(weightString) Weight Entry")
                    .font(.title2)
                    .bold()
                    .padding()
                    .foregroundStyle(.white)
                
                HStack {
                    EntryFieldView(
                        textBinding: $currentWeight,
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
                .disabled(Double(currentWeight) ?? 401.0 > 400 )

                if currentWeightEntry != nil {
                    LongPressButton {
                        handleAction(actionType: .delete)
                    }
                    .padding(.horizontal)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack{
                    HStack{
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .tint(.white)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .scaleEffect(scale)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 0.2)) {
                scale = 1.0
            }
            
        }
    }
    
    func handleAction(actionType: WeightEntryAction) {
        close()
        var weightEntry = currentWeightEntry ?? WeightEntry(weight: Double(self.currentWeight) ?? 0, entryDate: self.selectedDate)
        switch actionType {
        case .create:
            self.action(weightEntry, .create)
        case .update:
            weightEntry.weight = Double(self.currentWeight) ?? 0
            weightEntry.entryDate = self.selectedDate
            self.action(weightEntry, .update)
        case .delete:
            self.action(weightEntry, .delete)
        }
        
    }
    
    func close() {
        withAnimation(.linear(duration: 0.15)) {
            scale = 0.0
            presentEntryView = false
        }
    }
}

public enum WeightEntryAction {
    case create
    case update
    case delete
}


#Preview {
    WeightEntryView(presentEntryView: .constant(true), currentWeightEntry: WeightEntry.sampleWeightEntryList[4]){ _,_ in
        print("test")
        
    }
    .preferredColorScheme(.dark)
}
