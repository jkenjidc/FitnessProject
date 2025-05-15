//
//  StartRoutineCircleGraphic.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/4/24.
//

import SwiftUI

struct StartRoutineCircleGraphic: View{
    @Environment(Router.self) var router
    @Binding var routine: Routine
    var body: some View {
        Button {
            router.push(destination: .timerScreen(routine: routine))
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
    StartRoutineCircleGraphic(routine: .constant(Routine.example[0]) )
        .environment(Router())
}
