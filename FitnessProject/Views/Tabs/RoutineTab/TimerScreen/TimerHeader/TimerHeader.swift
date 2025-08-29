//
//  TimerHeader.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/14/25.
//

import SwiftUI

extension TimerScreen {
    struct TimerHeader: View {
        var viewModel = ViewModel()

        init(routineName: String) {
            viewModel = .init(routineName: routineName)
        }

        var body: some View {
            ZStack(alignment: .bottom) {
                curvedHeader
                pauseButton
            }
            .ignoresSafeArea(.all, edges: .top)
            .padding(.bottom, 30)
            .frame(height: 250)
            .onReceive(viewModel.timer){ _ in
                if viewModel.isPaused { return }
                viewModel.elapsedTime += 1
            }
        }

        var curvedHeader: some View {
            VStack {
                Spacer()
                Text(viewModel.routineName)
                    .font(.system(size: 30))
                    .padding(.top)
                Text(viewModel.timeString)
                    .font(.system(size: 45))
                    .bold()
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(
                CurvedHeaderView()
                    .fill(viewModel.backgroundColor)
            )
        }

        var pauseButton: some View {
            Button{
                withAnimation(nil) {
                    viewModel.isPaused.toggle()
                }
            } label: {
                Image(systemName: viewModel.buttonIconName)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .foregroundColor(viewModel.buttonColor)
            }
            .background(
                Circle()
                    .fill(Color.black)
                    .frame(width: 110, height: 110)
            )
            .offset(y: 45)
        }

    }

}

#Preview {
    TimerScreen.TimerHeader(routineName: "Sample Routine")
        .preferredColorScheme(.dark)
}
