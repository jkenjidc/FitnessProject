//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct RoutineListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var action: Int? = 0
    @State private var showRoutineLimitAlert = false
    var body: some View {
        NavigationStack{
            VStack {
                if dataManager.user.routines.isEmpty {
                    ContentUnavailableView{
                        Image(systemName: "figure.flexibility")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.secondary)
                    } description: {
                        Text("No routines added")
                    }
                    .navigationTitle("Routines")
                } else {
                    List{
                        ForEach(dataManager.user.routines){ routine in
                            RoutineListCellView(title: routine.name)
                        }
                        .onDelete(perform: { indexSet in
                            dataManager.deleteRoutine(at: indexSet)
                        })
                    }
                }
                
                
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        CreateRoutineView()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    .disabled(dataManager.hasHitRoutineLimit)
                    .buttonStyle(.plain)
                    .onTapGesture {
                        if dataManager.hasHitRoutineLimit {
                            showRoutineLimitAlert = true
                        }
                    }
                    .alert("You can only make 5 routines", isPresented: $showRoutineLimitAlert) {
                        Button("Ok") {}
                    }
                }
            }
            .navigationTitle("Routines")
        }
    }
}

#Preview {
    RoutineListView()
        .environmentObject(DataManager())
        .preferredColorScheme(.dark)
    //    RoutineListView(routines: [])
}
