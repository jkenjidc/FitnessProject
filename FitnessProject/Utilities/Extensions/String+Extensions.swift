//
//  String+Extensions.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/15/26.
//

import Foundation

extension String {
    /// Turns a wger HTML description into plain-text steps.
    /// Uses `<li>` items when present, otherwise `<p>` blocks, otherwise the whole text.
    func htmlToInstructionSteps() -> [String] {
        for tag in ["li", "p"] {
            let steps = matches(ofTag: tag).map(\.strippingHTML).filter { !$0.isEmpty }
            if !steps.isEmpty { return steps }
        }
        let text = strippingHTML
        return text.isEmpty ? [] : [text]
    }

    private func matches(ofTag tag: String) -> [String] {
        guard let regex = try? NSRegularExpression(
            pattern: "<\(tag)\\b[^>]*>(.*?)</\(tag)>",
            options: [.caseInsensitive, .dotMatchesLineSeparators]
        ) else { return [] }

        let range = NSRange(startIndex..., in: self)
        return regex.matches(in: self, range: range).compactMap { match in
            Range(match.range(at: 1), in: self).map { String(self[$0]) }
        }
    }

    private var strippingHTML: String {
        replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
