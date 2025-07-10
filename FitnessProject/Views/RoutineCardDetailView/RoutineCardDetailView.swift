//
//  RoutineCardDetailView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/8/24.
//

import SwiftUI

struct RoutineCardDetailView: View {
    var routine: Routine
    @Environment(Router.self) var router
    @State private var scale = 0.0
    var body: some View {
        VStack{
            Text(routine.name)
                .font(.title2)
                .bold()
                .padding()
                .foregroundStyle(.white)

            VStack {
                ForEach(routine.exercises){ exercise in
                    HStack{
                        Text("\(String(exercise.sets.count)) x \(exercise.name)")
                            .foregroundStyle(.white)
                        Spacer()
                        let index = String( (routine.exercises.firstIndex(where: {exercise.id == $0.id}) ?? 0) + 1)
                        Text(index)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
            }
            Button {
                router.push(destination: .timerScreen(routine: routine))
            } label: {
                Text("Start Routine")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.accentColor.opacity(0.6))
                    .cornerRadius(20)
            }
            .padding(.horizontal)

            Button {
                router.push(destination: .createRoutineScreen(routine: routine, screenMode: .editing))
            } label: {
                Text("Edit Routine")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.secondary.opacity(0.6))
                    .cornerRadius(20)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    RoutineCardDetailView(routine: Routine.example[1])
        .environment(Router())
}
