//
//  ExerciseV2Request.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import Foundation

struct ExerciseV2Request  {
    static var request : URLRequest {
        let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises?limit=50&offset=0")!
        var request = URLRequest(url: url)
        request.addValue(API.key, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(API.header, forHTTPHeaderField: "x-rapidapi-host")
        return request
    }
}
