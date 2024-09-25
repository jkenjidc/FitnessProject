//
//  WelcomeView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    @Environment(AppState.self) var appState
    @State private var viewModel = ViewModel()
    var welcomeLabelFontsize: CGFloat {
        if UIScreen.main.bounds.width < 380 {
            return CGFloat(30)
        }
        else {
            return CGFloat(40)
        }
    }
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Spacer()
                    Button{
                        viewModel.showGuestModeAlert.toggle()
                    } label: {
                        Label("Guest Sign In", systemImage: "person.crop.square")
                    }
                    .padding(5)
                    .buttonStyle(.plain)
                }
                Spacer()
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
                Spacer()
                Spacer()
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Log In")
                        .font(.system(size: 30))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 4)
                                .frame(width: 250, height: 50)
                        )
                        .frame(width: 200, height: 50)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 15)
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 30))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 4)
                                .frame(width: 250, height: 50)
                        )
                        .frame(width: 200, height: 50)
                }
                .buttonStyle(.plain)
                
                
            }
            .alert("Guest Mode", isPresented: $viewModel.showGuestModeAlert ){
//                Button("cancel", role: .none){}
                Button(role: .destructive){
                    Task {
                        do {
                            try await viewModel.signInAnonymously()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("OK")
                }
            } message: {
                Text("Any data created will be lost when the app is deleted, do you wish to proceed?")
            }
            .padding()
        }
        
    }
}

#Preview {
    WelcomeView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
