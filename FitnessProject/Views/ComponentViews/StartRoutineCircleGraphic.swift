//
//  StartRoutineCircleGraphic.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/4/24.
//

import SwiftUI

struct StartRoutineCircleGraphic: View{
    @Environment(Router.self) var router
    @Environment(RoutineService.self) var routineService
    var routineId: String

    var routine: Routine? {
        routineService.routines.first(where: { $0.id == routineId})
    }
    var body: some View {
        Button {
            router.push(destination: .timerScreen(routine: routine!))
            print("*****CIRCLE GRAHIC DATA SENT \(routine!.exercises)")
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
                Text(routine!.name)
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
    StartRoutineCircleGraphic(routineId: Routine.example[0].id )
        .environment(Router())
}
