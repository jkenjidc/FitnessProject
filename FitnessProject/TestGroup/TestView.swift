////
////  TestView.swift
////  FitnessProject
////
////  Created by Kenji Dela Cruz on 9/6/24.
////
//
//import SwiftUI
//import FirebaseAuth
//
//struct TestView: View {
//    @EnvironmentObject var dataManager: DataManager
//    var body: some View {
//        NavigationStack {
//            List(dataManager.dogs, id: \.id){ dog in
//                Text(dog.name)
//            }
//            .navigationTitle("Dogs")
//            .toolbar {
//                ToolbarItem{
//                    Button {
//                        do {
//                            try Auth.auth().signOut()
//                            dataManager.isLoggedIn = false
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                    } label: {
//                        Text("Out")
//                    }
//                }
//                
//                ToolbarItem {
//                    Button {
//                        dataManager.saveDogs()
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    TestView()
//}
