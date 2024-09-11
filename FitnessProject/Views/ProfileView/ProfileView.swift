//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        Button {
            dataManager.isLoggedIn = false
        } label: {
            Text("log out")
        }
    }
}

#Preview {
    ProfileView()
}
