//
//  WelcomeView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    @Environment(Router.self) var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.signInPath) {
            VStack {
                GuestSignInButton()

                Spacer()

                BannerView()

                Spacer()

                VStack(spacing: 20) {
                    Button("Log In") {
                        router.push(destination: .signInScreen)
                    }
                    .buttonStyle(.fitness)

                    Button("Sign Up") {
                        router.push(destination: .signUpScreen)
                    }
                    .buttonStyle(.fitness)
                }
            }
            .padding(10)
        }
    }
}

extension WelcomeView {
    struct GuestSignInButton: View {
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
                        // TODO: Refactor to use app coordinator
                        do {
                            let authDataResult =  try await AuthManager.shared.signInAnonymously()
                            let user = CurrentUser(auth: authDataResult)
                            try await DataManager.shared.createUser(user: user)
                            try await DataManager.shared.loadUser()
                        } catch {
                            print(error.localizedDescription)
                        }
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
    WelcomeView()
        .preferredColorScheme(.dark)
        .environment(Router())
}
