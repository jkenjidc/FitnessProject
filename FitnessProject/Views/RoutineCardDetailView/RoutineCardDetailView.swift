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
    @State private var offset = 1000.0
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.1)
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
                        Text(exercise.name)
                            .foregroundStyle(.white)
                    }
                }
                ZStack{
                    Button {
                        close()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.red)
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
            .background(.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .tint(.black)
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
        }
        }
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            router.dismissCover()
            presentDetailView = false
            
        }
    }
}

#Preview {
    RoutineCardDetailView(routine: Routine.example[1], presentDetailView: .constant(true))
        .environment(Router())
//    .preferredColorScheme(.dark)
}
