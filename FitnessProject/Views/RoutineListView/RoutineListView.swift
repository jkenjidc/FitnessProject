//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct RoutineListView: View {
    @Environment(Router.self) var router
    @State private var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        ZStack{
            VStack {
                if dataManager.routines.isEmpty {
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
                        ForEach($dataManager.routines){ $routine in
                            Button{
                                viewModel.presentRoutineDetailCard(routine: routine)
                            } label: {
                                RoutineListCellView(title: routine.name)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: { indexSet in
                            Task{
                                await viewModel.deleteRoutine(at: indexSet)
                            }
                        })
                    }
                }
                
                
                HStack {
                    Spacer()
                    
                    Button {
                        router.push(destination: .createRoutineScreen(routine: nil, screenMode: .creation))
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    .disabled(viewModel.hasHitLimit)
                    .buttonStyle(.plain)
                    .onTapGesture {
                        if viewModel.hasHitLimit {
                            viewModel.showRoutineLimitAlert = true
                        }
                    }
                    .onChange(of: dataManager.user.routines) { _, _ in
                        viewModel.hasHitLimit = dataManager.user.routines.count == 5
                    }
                    .alert("You can only make 5 routines", isPresented: $viewModel.showRoutineLimitAlert) {
                        Button("Ok") {}
                    }
                }
            }
            
            if viewModel.presentDialogueView {
                RoutineCardDetailView(routine: viewModel.selectedRoutine, presentDetailView: $viewModel.presentDialogueView)
            }
        }
        .navigationTitle("Routines")
    }
}
#Preview {
    RoutineListView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
