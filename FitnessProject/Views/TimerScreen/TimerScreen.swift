//
//  TimerScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/9/25.
//

import SwiftUI

struct TimerView: View {
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
                    Text("Push Day")
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
                .frame(height: 200)
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

            // Work, Rest, Rounds
            HStack {
                VStack {
                    Text("Work")
                    Text(workTime)
                }
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                .foregroundColor(.white)

                VStack {
                    Text("Rest")
                    Text(restTime)
                }
                .padding()
                .background(Color.purple)
                .cornerRadius(10)
                .foregroundColor(.white)

                VStack {
                    Text("Rounds")
                    Text("\(rounds)x")
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            .padding()

            // Lap Times
            VStack {
                ForEach(lapTimes.indices, id: \.self) { index in
                    HStack {
                        Text("Lap \(index + 1)")
                        Spacer()
                        Text(lapTimes[index])
                    }
                    .padding()
                    .background(index % 2 == 0 ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            .padding()

            // Weight and Reps Input
            VStack {
                HStack {
                    TextField("Weight", text: $weight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    TextField("Reps", text: $reps)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()
            }

            Spacer()
        }
        //        .padding()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.dark)
    }
}
