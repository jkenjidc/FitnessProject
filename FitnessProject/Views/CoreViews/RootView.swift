//
//  RootView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) var appState
    @Environment(Router.self) var router
    var body: some View {
        @Bindable var router = router
        ZStack{
            let initialScreen = (!AuthManager.shared.isSignedOut ? Destination.mainNavigationScreen : Destination.welcomeScreen)
            NavigationStack(path: $router.path){
                router.build(destination: initialScreen)
                    .navigationDestination(for: Destination.self) { destination in
                        router.build(destination: destination)
                    }
                    .sheet(item: $router.sheet){ sheet in
                        router.buildSheet(sheet: sheet)
                    }
                    .fullScreenCover(item: $router.fullScreenCover){ cover in
                        router.buildCover(cover: cover)
                    }
            }
        }
        .onAppear {
            Task{
                do{
                    try AuthManager.shared.checkAuth()
                    try await DataManager.shared.loadUser()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
