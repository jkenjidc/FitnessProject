//
//  TimerScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/9/25.
//

import SwiftUI

struct TimerView: View {
    let routine: Routine = .example[0]
    @State private var totalTime: String = "4:20"
    @State private var workTime: String = "0:45"
    @State private var restTime: String = "0:20"
    @State private var rounds: Int = 4
    @State private var lapTimes: [String] = ["00:30.56", "01:10.75", "00:27.28", "00:27.44"]
    @State private var weight: String = ""
    @State private var reps: String = ""

    var body: some View {
        VStack {
            // Timer Display
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    Text(routine.name)
                        .font(.system(size: 30))
                        .padding(.top)
                    Text("Total")
                        .font(.subheadline)
                    Text(totalTime)
                        .font(.system(size: 45))
                        .bold()
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(40)
                .foregroundColor(.white)
                .ignoresSafeArea()
                .frame(height: 300)
                Button(action: {
                    // Start/Stop Timer Action
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.pink)
                }
                .offset(y: 45)
            }
            .padding(.bottom, 30)

            // Lap Times
            ScrollView {
                HStack {
                    Text("Exercise")
                    Spacer()
                    Text("Last Attempt")
                }
                .foregroundStyle(.secondary)
                VStack {
                    ForEach(routine.exercises.indices, id: \.self) { index in
                        HStack {
                            Text(routine.exercises[index].name)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("2 Weeks ago")
                                Text("100lbs x 3")
                            }
                        }
                        .padding()
//                        .background(index % 2 == 0 ? Color.red.opacity(0.7) : Color.green.opacity(0.7))

                    }
                    .background(.blue.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                }


                // Weight and Reps Input
//                VStack {
//                    HStack {
//                        TextField("Weight", text: $weight)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.decimalPad)
//                        TextField("Reps", text: $reps)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .keyboardType(.numberPad)
//                    }
//                    .padding()
//                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 30)

            Spacer()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.dark)
    }
}
