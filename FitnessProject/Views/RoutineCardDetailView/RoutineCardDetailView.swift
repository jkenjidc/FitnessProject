//
//  RoutineCardDetailView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/8/24.
//

import SwiftUI

struct RoutineCardDetailView: View {
    var routine: Routine
    @Binding var presentDetailView: Bool
    @Environment(Router.self) var router
    @State private var scale = 0.0
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.2)
                .onTapGesture {
                    close()
                }
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
                ZStack{
                    Button {
                        close()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Start Routine")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding()
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
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .tint(.white)
                        Spacer()
                        
                        Button{
                            close()
                            router.push(destination: .createRoutineScreen(routine: routine))
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
            .scaleEffect(scale)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 0.2)) {
                scale = 1.0
            }
            
        }
    }
    
    func close() {
        withAnimation(.linear(duration: 0.15)) {
            scale = 0.0
            presentDetailView = false
        }
    }
}

#Preview {
    RoutineCardDetailView(routine: Routine.example[1], presentDetailView: .constant(true))
        .environment(Router())
//    .preferredColorScheme(.dark)
}
