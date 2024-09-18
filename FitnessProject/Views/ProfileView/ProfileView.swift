//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Button {
            appState.isLoggedIn = false
        } label: {
            Text("log out")
        }
    }
}

#Preview {
    ProfileView()
}
