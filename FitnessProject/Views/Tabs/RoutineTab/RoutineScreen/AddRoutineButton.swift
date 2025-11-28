//
//  RoutinesScreen+Components.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/9/25.
//

import SwiftUI

extension RoutinesScreen {
    struct AddRoutineButton: View {
        @Environment(Router.self) var router
        @Environment(RoutineService.self) var routineService
        @State private var showRoutineLimitAlert = false

        //TODO: Refactor to add limit somewhere centralized
        var hasHitLimit: Bool {
            routineService.routines.count == 5
        }

        var body : some View {
                Button {
                    if hasHitLimit {
                        showRoutineLimitAlert = true
                    } else {
                        router.push(destination: .editRoutineScreenV2(nil))
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .disabled(hasHitLimit)
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .alert("You can only make 5 routines", isPresented: $showRoutineLimitAlert) {
                    Button("Ok") {}
                }
        }
    }
}
