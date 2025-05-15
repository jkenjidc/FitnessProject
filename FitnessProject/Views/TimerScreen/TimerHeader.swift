//
//  TimerHeader.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/14/25.
//

import SwiftUI

extension TimerScreen {
    struct TimerHeader: View {
        @State private var totalTime: String = "4:20"
        let routineName: String

        var body: some View {
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    Text(routineName)
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
        }

    }
}


#Preview {
    TimerScreen.TimerHeader(routineName: "Sample Routine")
}
