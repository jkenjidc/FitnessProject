//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    @Environment(Router.self) var router
    @Environment(AuthService.self) var authService
    @Environment(UserService.self) var userService
    @State var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            ProfileImage(
                selectedItem: $viewModel.selectedItem,
                profileImage: viewModel.profileImage,
                loadImageFromPicker: viewModel.loadImageFromDirectory
            )

            //TODO: Remove after finalizing profile screen
            Text("User ID \(userService.user.id)")

            PreviousRoutineList(previousRoutines: dataManager.user.routineHistory)

            HStack(spacing: 0){
                Button(role: .destructive) {
                   try? authService.signOut()
                } label: {
                    Text("log out")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    router.push(destination: dataManager.user.isAnonymous ?  .signUpScreen : .updatePasswordScreen)
                } label: {
                    Text(dataManager.user.isAnonymous ? "Create Acount" : "Update password")
                }
            }
            .padding(.bottom, 15)
        }
        .padding(.horizontal, 16)
        .onAppear(perform: viewModel.loadImageFromDirectory)
        .frame(maxWidth: .infinity)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    router.push(destination: .settingsScreen)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                }
                .padding()
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ProfileScreen()
        .environment(Router())
        .preferredColorScheme(.dark)
}
