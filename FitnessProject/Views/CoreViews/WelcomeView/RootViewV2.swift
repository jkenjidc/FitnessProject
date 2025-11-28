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

    @MainActor func handleSetUp() async {
        do {
            if case .authenticated(let authdata) = authService.authState {
                try await userService.loadUser(userId: authdata.uid)
            }
            withAnimation {
                networkCallState = .loaded
            }
        } catch {
            // TODO: Handle error state
            Log.error("Failed to set up app: \(error)")
            networkCallState = .error(error)
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
            .transition(.move(edge: .leading))
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
            .transition(.move(edge: .trailing))
        }
    }
}


#Preview {
    RootViewV2()
        .environment(AuthService())
}
