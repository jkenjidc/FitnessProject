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
    var modal: Modal?
    var modalScale: CGFloat = 0
    // MARK: Router functions for navigation
    func push(destination: Destination) {
        dismissAll() //clear out all modals, sheets and covers
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

    func presentModal(_ modal: Modal){
        self.modal = modal
    }

    //MARK: Dismiss Functions
    func dismissAll() {
        dismissSheet()
        dismissCover()
        //TODO: Investigate why push doesnt work when dismissing using dismissModal()
        self.modal = nil
        self.modalScale = 0.0
    }

    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissCover(){
        self.fullScreenCover = nil
    }

    func dismissModal(){
        withAnimation(.linear(duration: 0.1)) {
            self.modalScale = 0.0
        } completion: {
            self.modal = nil
        }
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
        case .createRoutineScreen(let routine, let screenMode):
            CreateRoutineView(routine: routine, screenMode: screenMode)
        case .settingsScreen:
            SettingsView()
        case .updatePasswordScreen:
            UpdatePasswordView()
        case .timerScreen(let routine):
            TimerScreen(routine: routine)
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .addExerciseSheet(let viewModel):
            AddExerciseView(viewModel: viewModel)
        case .forgotPassswordSheet:
            ForgotPasswordView()
        case .streakInfo:
            StreakInfoSheet()
        }
    }
    
    @ViewBuilder
    func buildCover(cover: FullScreenCover) -> some View {
        switch cover {
        case .welcomeView:
            WelcomeView()
        case .weeklyStepView:
            HKWeeklyStepsCover()
        }
    }

    @ViewBuilder
    func buildModal(modal: Modal) -> some View {
        Group {
            switch modal {
            case .weightChartEntry(let viewModel):
                WeightEntryView(viewModel: viewModel)
            case .routineInfo(let routine):
                RoutineCardDetailView(routine: routine)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            VStack{
                HStack{
                    Button {
                        self.dismissModal()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .tint(.white)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .shadow(radius: 20)
        .padding(30)
        .scaleEffect(modalScale)
        .onAppear {
            withAnimation(.linear(duration: 0.2)) {
                self.modalScale = 1.0
            }
        }
    }
}
