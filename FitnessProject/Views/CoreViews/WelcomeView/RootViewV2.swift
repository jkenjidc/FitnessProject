//
//  RootViewV2.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/11/25.
//

import SwiftUI

struct RootViewV2: View {
    @Environment(AuthService.self) var authService

    var body: some View {
        if case .authenticated = authService.authState {
            MainNavigationScreen()
        } else {
            WelcomeScreen()
        }
    }
}

extension RootViewV2 {
    struct LogoView: View {
        var body: some View {
            VStack {
                Image(systemName: "dumbbell.fill")
                    .resizable()
                    .frame(width: 200, height: 130)

                Text("Fitness Project")
                    .font(.system(size: 24, weight: .bold))

                ProgressView()
                    .frame(width: 50, height: 50)
            }

        }
    }
}
#Preview {
    RootViewV2()
        .environment(AuthService())
}
