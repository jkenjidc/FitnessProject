//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) var appState
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
        .environment(AppState())
}
