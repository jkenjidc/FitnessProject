//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct RoutineListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State var routines: [Routine]
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
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Routines")
        }
    }
}

#Preview {
    RoutineListView(routines: Routine.example)
        .preferredColorScheme(.dark)
    //    RoutineListView(routines: [])
}
