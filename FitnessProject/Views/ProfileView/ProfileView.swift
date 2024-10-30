//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(Router.self) var router
    @State  var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        VStack(alignment: .center){
            ZStack(alignment: .topTrailing){
                if let profilePicture = viewModel.profileImage {
                    profilePicture
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .padding(.top, 15)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:180, height: 180)
                        .padding(.top, 15)
                }
                
                
                PhotosPicker(selection: $viewModel.selectedItem){
                    Image(systemName: "pencil")
                        .font(.system(size: 25))
                }
                .onChange(of: viewModel.selectedItem, viewModel.loadImage)
                .buttonStyle(.plain)
                .offset(x:5,y:20)
            }
            Text("User ID \(dataManager.user.id)")
                .padding(.bottom, 25)
            HStack{
                Button {
                    viewModel.signOut {
                        router.popToRoot()
                    }
                } label: {
                    Text("log out")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
                Spacer()
                Button {
                    router.push(destination: dataManager.user.isAnonymous ?  .signUpScreen : .updatePasswordScreen)
                } label: {
                    Text( dataManager.user.isAnonymous ? "Create Acount" : "Update password")
                }
            }
            .padding(.horizontal, 45)
            if let previousRoutines = dataManager.user.routineHistory{
                if !previousRoutines.isEmpty{
                    List {
                        Section{
                            ForEach(previousRoutines){ routine in
                                HStack{
                                    Text(routine.nameOfRoutine)
                                    Spacer()
                                    Text("\(routine.dateDone.formatted(date: .numeric, time: .omitted))")
                                }
                            }
                        } header: {
                            Text("Routine History")
                                .bold()
                                .font(.headline)
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
            Spacer()
            Button(role: .destructive) {
                viewModel.confirmAccountDeletion.toggle()
            } label: {
                Text("Delete Account")
            }
            .padding(.bottom, 25)
            .alert("Delete account", isPresented: $viewModel.confirmAccountDeletion){
                Button("OK", role: (.destructive)){
                    Task {
                        await viewModel.deleteAccount {
                            router.popToRoot()
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action can't be reversed")
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
