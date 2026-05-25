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
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .center, spacing: 20){
            ProfileImage(
                selectedItem: $selectedItem,
                profileImage: userService.profileImage,
                loadImageFromPicker: handlePickedItem
            )

            //TODO: Remove after finalizing profile screen
            Text("User ID \(userService.user.id)")

            PreviousRoutineList(previousRoutines: userService.user.routineHistory)

            HStack(spacing: 0){
                Button(role: .destructive) {
                   try? authService.signOut()
                } label: {
                    Text("log out")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    router.push(destination: userService.user.isAnonymous ?  .signUpScreen : .updatePasswordScreen)
                } label: {
                    Text(userService.user.isAnonymous ? "Create Acount" : "Update password")
                }
            }
            .padding(.bottom, 15)
        }
        .padding(.horizontal, 16)
        .onAppear { userService.loadCachedProfileImage() }
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

    private func handlePickedItem() {
        guard let item = selectedItem else { return }
        Task {
            do {
                try await userService.uploadProfileImage(from: item)
            } catch {
                Log.error("Profile image upload failed: \(error)")
            }
        }
    }
}

#Preview {
    ProfileScreen()
        .environment(Router())
        .preferredColorScheme(.dark)
}
