//
//  WelcomeView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI
import FirebaseAuth

struct WelcomeScreen: View {
    @Environment(Router.self) var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.authPath) {
            Content()
                .navigationDestination(for: Destination.self) { destination in
                    router.build(destination: destination)
                }
                .sheet(item: $router.sheet){ sheet in
                    router.buildSheet(sheet: sheet)
                }
        }
    }
}

extension WelcomeScreen {
    struct Content: View {
        @Environment(Router.self) var router
        var body: some View {
            VStack {
                GuestSignInButton()

                Spacer()

                BannerView()

                Spacer()

                VStack(spacing: 20) {
                    Button("Log In") {
                        router.pushInAuthFlow(destination: .signInScreen)
                    }
                    .buttonStyle(.fitness(.primary))

                    Button("Sign Up") {
                        router.pushInAuthFlow(destination: .signUpScreen)
                    }
                    .buttonStyle(.fitness(.primary))
                }
            }
            .padding(10)
        }
    }

    struct GuestSignInButton: View {
        @Environment(AppCoordinator.self) var appCoordinator
        @State private var showGuestModeAlert: Bool = false
        var body: some View {
            Button{
                showGuestModeAlert.toggle()
            } label: {
                Label("Guest Sign In", systemImage: "person.crop.square")
            }
            .padding(5)
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .alert("Guest Mode", isPresented: $showGuestModeAlert ){
                Button(role: .destructive){
                    Task {
                        try? await appCoordinator.signInAnonymously()
                    }
                } label: {
                    Text("OK")
                }
            } message: {
                Text("Any data created will be lost when the app is deleted, do you wish to proceed?")
            }
        }
    }

    struct BannerView: View {
        var body: some View {
            HStack{
                Image(systemName: "dumbbell")
                    .resizable()
                    .frame(width: 120, height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 5)
                            .frame(width: 200, height: 200)
                    )
                    .frame(width: 200, height: 200)
                Text("Welcome to the app")
                    .font(.system(size: welcomeLabelFontsize))
                    .multilineTextAlignment(.leading)
            }
        }

        var welcomeLabelFontsize: CGFloat {
            if UIScreen.main.bounds.width < 380 {
                return CGFloat(30)
            }
            else {
                return CGFloat(40)
            }
        }
    }
}

#Preview {
    WelcomeScreen()
        .preferredColorScheme(.dark)
        .environment(Router())
}
