//
//  BackButton.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/28/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(Router.self) var router
    var navigationMode: NavigationMode = .screen
    init(navigationMode: NavigationMode? = .screen) {
        self.navigationMode = navigationMode ?? self.navigationMode
    }
    var body: some View {
        HStack{
            Button {
                switch navigationMode {
                    case .screen: router.pop()
                    case .fullScreenCover: router.dismissCover()
                    case .sheet: router.dismissSheet()
                }
            } label: {
                HStack(spacing: 5){
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

enum NavigationMode {
    case sheet
    case fullScreenCover
    case screen

}

#Preview {
    BackButton()
        .environment(Router())
}
