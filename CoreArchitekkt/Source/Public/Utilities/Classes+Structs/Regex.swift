//
//  Regex.swift
//  Nimble
//
//  Created by Stephan Lerner on 27.05.18.
//

import Foundation

public struct Regex {

    // MARK: - Public -

    public static func getMatches(for regex: String, text: String) throws -> [NSTextCheckingResult] {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        return regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
    }

    public static func getMatchingStrings(for regex: String, text: String, captureGroup: Int) throws -> [String] {
        let matches = try getMatches(for: regex, text: text)
        var matchingStrings: [String] = []
        for match in matches {
            if let matchingString = Range(match.range(at: captureGroup), in: text).map({String(text[$0])}) {
                matchingStrings.append(matchingString)
            }
        }
        return matchingStrings
    }

}
