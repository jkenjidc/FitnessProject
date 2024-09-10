////
////  ContentView.swift
////  FitnessProject
////
////  Created by Kenji Dela Cruz on 9/6/24.
////
//
//import SwiftUI
//import Firebase
//import FirebaseAuth
//
//struct ContentView: View {
//    @EnvironmentObject var dataManager: DataManager
//    @State private var email = ""
//    @State private var password = ""
//    var body: some View {
//        if dataManager.isLoggedIn {
//            TestView()
//                .environmentObject(dataManager)
//        } else {
//            VStack {
//                TextField("email", text: $email)
//                TextField("password", text: $password)
//                
//                Button {
//                    register()
//                } label: {
//                    Text("Sign up")
//                }
//                
//                Button {
//                    login()
//                } label: {
//                    Text("Log in")
//                }
//            }
//            .onAppear {
//                Auth.auth().addStateDidChangeListener { auth, user in
//                    if user != nil {
//                        dataManager.isLoggedIn =  true
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//    
//    func register() {
//        Auth.auth().createUser(withEmail: email, password: password){ result, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
//    
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
