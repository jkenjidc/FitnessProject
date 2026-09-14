//
//  RootViewV2.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/11/25.
//

import SwiftUI

struct RootViewV2: View {
    @Environment(UserService.self) var userService
    @Environment(AuthService.self) var authService
    @State var networkCallState: FirebaseCallState = .loading

    var body: some View {
        Group {
            switch networkCallState {
                case .loading:
                LogoView()
            case .loaded:
                Content()
            case .error(let error):
                Text("Error: \(error)")
                    .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .task {
            await handleSetUp()
        }
    }

    /// Shortest time the logo stays up. Setup usually finishes well inside this, so
    /// without it the splash flashes by rather than reading as a deliberate screen.
    private static let minimumSplashDuration: Duration = .milliseconds(700)

    @MainActor func handleSetUp() async {
        let startedAt = ContinuousClock.now
        let result: FirebaseCallState

        do {
            // Resolve the persisted session first — the splash stays up until Firebase
            // has restored it, so the Firestore read below always has a usable token.
            await authService.checkAuth()

            if case .authenticated(let authdata) = authService.authState {
                try await userService.loadUser(userId: authdata.uid)
            }
            result = .loaded
        } catch {
            // TODO: Handle error state
            Log.error("Failed to set up app: \(error)")
            result = .error(error)
        }

        let elapsed = ContinuousClock.now - startedAt
        if elapsed < Self.minimumSplashDuration {
            try? await Task.sleep(for: Self.minimumSplashDuration - elapsed)
        }

        withAnimation(.easeInOut(duration: 0.35)) {
            networkCallState = result
        }
    }
}

fileprivate extension RootViewV2 {
    struct Content: View {
        @Environment(AuthService.self) var authService
        var body: some View {
            Group {
                if case .authenticated = authService.authState {
                    MainNavigationScreen()
                } else {
                    WelcomeScreen()
                }
            }
            .transition(.opacity)
        }
    }

    struct LogoView: View {
        var body: some View {
            VStack {
                // TODO: Animate this to actually run
                Image(systemName: "figure.run")
                    .resizable()
                    .frame(width: 85, height: 130)

                Text("Fitness Project")
                    .font(.system(size: 24, weight: .bold))

                ProgressView()
                    .frame(width: 50, height: 50)
            }
            .transition(.opacity)
        }
    }
}


#Preview {
    RootViewV2()
        .environment(AuthService())
}
