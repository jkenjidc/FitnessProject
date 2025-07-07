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
                router.dismissModal()
                router.push(destination: .createRoutineScreen(routine: routine, screenMode: .timer))
            } label: {
                Text("Start Routine")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.accentColor.opacity(0.6))
                    .cornerRadius(20)
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            VStack{
                HStack{
                    Button {
                        router.dismissModal()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .tint(.white)
                    Spacer()

                    Button{
                        router.dismissModal()
                        router.push(destination: .createRoutineScreen(routine: routine, screenMode: .editing))
                    } label: {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .tint(.white)
                }
                Spacer()
            }
            .padding()
        }
        .shadow(radius: 20)
        .padding(30)
    }
}

#Preview {
    RoutineCardDetailView(routine: Routine.example[1])
        .environment(Router())
}
