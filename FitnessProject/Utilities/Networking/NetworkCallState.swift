//
//  NetworkCallState.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/18/25.
//

import Foundation

enum NetworkCallState<T> {
    case loading
    case loaded(T)
    case error(Error)
}

enum FirebaseCallState {
    case loading
    case loaded
    case error(Error)
}
