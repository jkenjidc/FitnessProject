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
            
                Task {
                    do {
                        try withAnimation {
                            try appState.shared.signOut()
                        }
                    } catch {
                        print(error)
                    }
            }
        } label: {
            Text("log out")
        }
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
}
