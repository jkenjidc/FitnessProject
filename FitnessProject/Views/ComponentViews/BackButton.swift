//
//  BackButton.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/28/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(Router.self) var router
    var body: some View {
        HStack{
            Button {
                router.pop()
            } label: {
                HStack(spacing: 5){
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
            .padding(.leading)
            Spacer()
        }
    }
}

#Preview {
    BackButton()
        .environment(Router())
}
