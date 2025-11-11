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
        Group {
            switch authService.authState {
            case .idle, .authenticating:
                LogoView()

            case .unauthenticated:
                WelcomeView()

            case .authenticated:
                MainNavigationView()

            case .error(let authError):
                ErrorView(error: authError)
            }
        }
        .task {
            authService.checkAuth()
            if case .authenticated = authService.authState {
                do {
                    try AuthManager.shared.checkAuth()
                    try await DataManager.shared.loadUser()
                } catch {
                    Log.error("Failed to load user: \(error)")
                }
            }
        }
    }
}

extension RootViewV2 {
    struct ErrorView: View {
        @Environment(AuthService.self) var authService
        let error: AuthError
        var body: some View {
            VStack {
                ContentUnavailableView(
                    "Authentication Error",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error.localizedDescription)
                )

                Button("Retry") {
                    authService.checkAuth()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

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
