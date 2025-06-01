//
//  TimerHeader.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/14/25.
//

import SwiftUI

extension TimerScreen {
    struct TimerHeader: View {
        @State var elapsedTime: TimeInterval = 0
        @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var timeString: String {
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            let hour = Int(minutes) / 60
            return String(format: "%02d.%02d.%02d", hour, minutes, seconds)
        }
        @State var isPaused: Bool = false
        let routineName: String

        var body: some View {
            let theme = HeaderTheme($isPaused)
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()
                    Text(routineName)
                        .font(.system(size: 30))
                        .padding(.top)
                    Text(timeString)
                        .font(.system(size: 45))
                        .bold()
                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(
                    CurvedHeaderView()
                        .fill(theme.backgroundColor)
                )
                Button{
                    withAnimation(nil) {
                        isPaused.toggle()
                    }
                } label: {
                    Image(systemName: theme.buttonIconName)
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(theme.buttonColor)
                }
                .background(
                    Circle()
                        .fill(Color.black)
                        .frame(width: 110, height: 110)
                )
                .offset(y: 45)
            }
            .ignoresSafeArea(.all, edges: .top)
            .padding(.bottom, 30)
            .frame(height: 250)
            .onReceive(timer){ _ in
                if isPaused { return }
                elapsedTime += 1
            }
        }

    }

}
private extension TimerScreen.TimerHeader {
    class HeaderTheme: ObservableObject {
        @Binding var isPaused: Bool

        init(_ state: Binding<Bool>) {
            self._isPaused = state
        }
        
        var buttonColor: Color {
            isPaused ? .blue : .gray
        }

        var backgroundColor: Color {
            isPaused ? .gray : .blue
        }

        var buttonIconName: String {
            isPaused ? "play.circle.fill" :"pause.circle.fill"
        }
    }
}



#Preview {
    TimerScreen.TimerHeader(routineName: "Sample Routine")
        .preferredColorScheme(.dark)
}
