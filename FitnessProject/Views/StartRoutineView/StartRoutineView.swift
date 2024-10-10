//
//  StartRoutineView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/10/24.
//

import SwiftUI

@MainActor
struct StartRoutineView: View {
    @State private var viewModel = ViewModel()
    var body: some View {
        ScrollView(.horizontal){
            HStack(alignment: .center){
                Spacer()
                ForEach(viewModel.routinesForTheDay) { routine in
                    StartRoutineCircleGraphic(routine: routine)
                }
                Spacer()
            }
            .background(.yellow)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(.orange)
        
    }
}

struct StartRoutineCircleGraphic: View{
    var routine: Routine
    var body: some View {
        Button {
        } label: {
            startButtonlabel
        }
        .buttonStyle(.plain)
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
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    StartRoutineCircleGraphic(routine: Routine.example[0])
}
