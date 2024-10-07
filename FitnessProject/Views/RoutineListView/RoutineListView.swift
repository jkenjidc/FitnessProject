//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

@MainActor
struct RoutineListView: View {
    @Environment(AppState.self) var appState
    @Environment(Router.self) var router
    @State private var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
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
                    ForEach($dataManager.user.routines){ $routine in
                        Button{
                            router.push(destination: .createRoutineScreen(routine: routine))
                        } label: {
                            RoutineListCellView(title: routine.name)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: { indexSet in
                        appState.deleteRoutine(at: indexSet)
                    })
                }
            }
            
            
            HStack {
                Spacer()
                
                Button {
                    router.push(destination: .createRoutineScreen(routine: nil))
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .disabled(appState.hasHitRoutineLimit)
                .buttonStyle(.plain)
                .onTapGesture {
                    if appState.hasHitRoutineLimit {
                        viewModel.showRoutineLimitAlert = true
                    }
                }
                .alert("You can only make 5 routines", isPresented: $viewModel.showRoutineLimitAlert) {
                    Button("Ok") {}
                }
            }
        }
//        .onAppear {
//            Task {
//                await viewModel.loadData()
//            }
//        }
        .navigationTitle("Routines")
    }
}
#Preview {
    RoutineListView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
