//
//  WgerRequest.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/15/26.
//

import Foundation

/// Requests for the public wger API (https://wger.de/api/v2/). Exercise endpoints need no API key.
struct WgerRequest {
    static let baseURL = URL(string: "https://wger.de/api/v2/")!
    static let englishLanguageId = 2

    static func exerciseInfo(offset: Int = 0, limit: Int = 100) -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent("exerciseinfo/"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "language", value: String(englishLanguageId)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        return request(for: components.url!)
    }

    static func request(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
