//
//  Router.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/18/24.
//

import Foundation
import SwiftUI

@Observable
class Router {
    var path: NavigationPath = NavigationPath()
    var sheet: Sheet?
    var fullScreenCover: FullScreenCover?
    
    // MARK: Router functions for navigation
    func push(destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    // MARK: Presentation functions
    func presentSheet(_ sheet: Sheet){
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover){
        self.fullScreenCover = cover
    }
    
    //MARK: Dismisall Functions
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissCover(){
        self.fullScreenCover = nil
    }
    
    
    // MARK: Builder functions
    @ViewBuilder
    func build(destination: Destination) -> some View {
        switch destination {
        case .signInScreen:
            SignInView()
        case .signUpScreen:
            SignUpView()
        case .mainNavigationScreen:
            MainNavigationView()
        case .welcomeScreen:
            WelcomeView()
        case .createRoutineScreen:
            CreateRoutineView()
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .addExerciseSheet(let viewModel):
            AddExerciseView(viewModel: viewModel)
        }
    }
    
    @ViewBuilder
    func buildCover(cover: FullScreenCover) -> some View {
        switch cover {
        case .welcomeView:
            WelcomeView()
        }
    }
}
