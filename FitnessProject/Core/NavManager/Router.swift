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
    var routinesPath: NavigationPath = NavigationPath()
    var exercisesPath: NavigationPath = NavigationPath()
    var progressPath: NavigationPath = NavigationPath()
    var authPath: NavigationPath = NavigationPath()
    var currentTab: Tabs = .routines
    var sheet: Sheet?
    var fullScreenCover: FullScreenCover?
    var modal: Modal?
    var modalScale: CGFloat = 0
    var currentPath: NavigationPath {
            get {
                switch currentTab {
                case .exercises:
                    return exercisesPath
                case .routines:
                    return routinesPath
                case .progress:
                    return progressPath
                }
            }
            set {
                switch currentTab {
                case .exercises:
                    exercisesPath = newValue
                case .routines:
                    routinesPath = newValue
                case .progress:
                    progressPath = newValue
                }
            }
        }

    // MARK: Router functions for navigation
    func push(destination: Destination) {
        dismissAll() //clear out all modals, sheets and covers
        currentPath.append(destination)
    }

    func pop() {
        currentPath.removeLast()
    }
    
    func popToRoot() {
        currentPath.removeLast(currentPath.count)
    }

    func pushInAuthFlow(destination: Destination) {
        // For welcome/sign in flow
        authPath.append(destination)
    }

    func popFromAuthFlow() {
        guard !authPath.isEmpty else { return }
        authPath.removeLast()
    }

    func reset() {
        routinesPath = NavigationPath()
        progressPath = NavigationPath()
        exercisesPath = NavigationPath()
        authPath = NavigationPath()
        currentTab = .routines
        dismissAll()
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
        case .profileScreen:
            ProfileScreen()
        case .signInScreen:
            SignInScreen()
        case .signUpScreen:
            SignUpScreen()
        case .mainNavigationScreen:
            MainNavigationScreen()
        case .welcomeScreen:
            WelcomeScreen()
        case .createRoutineScreen(let routine, let screenMode):
            CreateRoutineScreen(routine: routine, screenMode: screenMode)
        case .settingsScreen:
            SettingsView()
        case .updatePasswordScreen:
            UpdatePasswordView()
        case .timerScreen(let routine):
            TimerScreen(routine: routine)
        case .editRoutineScreenV2(let routine):
            EditRoutineScreen(routine: routine)
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
        case .exerciseDetail(let exercise):
            ExerciseDetailSheet(exercise: exercise)
        case .addExerciseSheetV2:
            Text("Test")
        }
    }
    
    @ViewBuilder
    func buildCover(cover: FullScreenCover) -> some View {
        switch cover {
        case .welcomeView:
            WelcomeScreen()
        case .weeklyStepView:
            HKWeeklyStepsCover()
        }
    }

    // TODO: remove this from the router
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

enum Tabs: String {
    case exercises = "exercises"
    case routines  = "routines"
    case progress = "progress"

    var systemImageName: String {
        switch self {
        case .exercises:
            return "figure.run"
        case .routines:
            return "dumbbell.fill"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        }
    }
}
