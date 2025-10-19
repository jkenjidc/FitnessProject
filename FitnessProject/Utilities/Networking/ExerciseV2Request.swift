//
//  ExerciseV2Request.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import Foundation

struct ExerciseV2Request  {
    static func request(offset: Int = 0) -> URLRequest {
        let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises?offset=\(offset)")!
        return attachHeaders(for: url)
    }

    static func imageRequest(exerciseId: String) -> URLRequest {
        let url = URL(string: "https://exercisedb.p.rapidapi.com/image")!
        var request = attachHeaders(for: url)
        request.addValue(exerciseId, forHTTPHeaderField: "exerciseId")
        request.addValue("180", forHTTPHeaderField: "resolution")
        return request
    }

    static func attachHeaders(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(API.key, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(API.header, forHTTPHeaderField: "x-rapidapi-host")
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
}
