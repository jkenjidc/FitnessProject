//
//  StartRoutineView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/10/24.
//

import SwiftUI

struct StartRoutineView: View {
    @State private var viewModel = ViewModel()
    var body: some View {
        if !viewModel.routinesForTheDay.isEmpty {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center){
                    ForEach(viewModel.routinesForTheDay) { routine in
                        StartRoutineCircleGraphic(routine: routine)
                    }
                }
                .scrollTargetLayout()
            }
            .transition(.scale)
            .scrollTargetBehavior(.paging)
            .scrollBounceBehavior(.basedOnSize)
        } else {
            ContentUnavailableView {
                Image(systemName: "play.slash.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.secondary)
            } description: {
                Text("Create routines in the routines tab")
            }
        }

        
    }
}

struct StartRoutineCircleGraphic: View{
    @Environment(Router.self) var router
    var routine: Routine
    var body: some View {
        Button {
            router.push(destination: .createRoutineScreen(routine: routine, timerMode: true))
        } label: {
            startButtonlabel
        }
        .buttonStyle(.plain)
        .containerRelativeFrame(.horizontal)
        
    }
    
    var startButtonlabel: some View {
        return ZStack {
            Circle()
                .foregroundStyle(.secondary)
                .opacity(0.5)
            VStack{
                Text(routine.name)
                    .font(.system(size: 25).weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 15)
                Image(systemName: "play")
                    .font(.system(size: 45))
                    .foregroundStyle(.white)
            }
            .transition(.opacity)
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    StartRoutineCircleGraphic(routine: Routine.example[0])
        .environment(Router())
}
