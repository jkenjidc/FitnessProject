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
    public enum Destination: Codable, Hashable {
        case signInScreen
        case signUpScreen
        case mainNavigationScreen
    }
    
    public enum Sheet: String, Identifiable {
        var id: String {
            self.rawValue
        }
        case addExercise
    }
    
    public enum FullScreenCover: String, Identifiable {
        var id: String {
            self.rawValue
        }
        
        case welcomeView
    }
    var path = NavigationPath()
    var sheet: Sheet?
    var fullScreenCover: FullScreenCover?
    
    func push(destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet(_ sheet: Sheet){
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover){
        self.fullScreenCover = cover
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissCover(){
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(destination: Destination) -> some View {
        switch destination {
        case .signInScreen:
            SignInView()
        case .signUpScreen:
            SignUpView()
        case .mainNavigationScreen:
            MainNavigationView()
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet, viewModel: AnyObject) -> some View {
        switch sheet {
        case .addExercise:
            AddExerciseView(viewModel: viewModel as! Binding<CreateRoutineView.ViewModel>)
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
