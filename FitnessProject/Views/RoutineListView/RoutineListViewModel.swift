//
//  RoutineListViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/7/24.
//

import Foundation

extension RoutineListView {
    @MainActor
    @Observable class ViewModel {
        var user = DataManager.shared.user 
        var action: Int? = 0
        var showRoutineLimitAlert = false
        
    }
    
    
    
}
