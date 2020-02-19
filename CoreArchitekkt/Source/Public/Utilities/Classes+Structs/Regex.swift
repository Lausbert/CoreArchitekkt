//
//  Regex.swift
//  Nimble
//
//  Created by Stephan Lerner on 27.05.18.
//

import Foundation

public struct Regex {

    // MARK: - Public -

    public struct CombinedResult {
        let results: [Result]
    }

    public struct Result {
        let captureGroup: Int
        let string: String
        let range: Range<String.Index>
        let regex: String
        let text: String
    }

    public static func getMatchingStrings(for regex: StaticString, text: String, captureGroup: Int) -> [Result] {
        return getMatchingStrings(for: regex, text: text, captureGroups: captureGroup).flatMap { $0.results }
    }

    public static func getMatchingStrings(for regex: String, text: String, captureGroup: Int) throws -> [Result] {
        return try getMatchingStrings(for: regex, text: text, captureGroups: captureGroup).flatMap { $0.results }
    }

    public static func getMatchingStrings(for regex: StaticString, text: String, captureGroups: Int...) -> [CombinedResult] {
        let matches = try! getMatches(for: "\(regex)", text: text)
        return matches.map { match in
            getMachingStrings(for: match, regex: "\(regex)", text: text, captureGroups: captureGroups)
        }
    }

    public static func getMatchingStrings(for regex: String, text: String, captureGroups: Int...) throws -> [CombinedResult] {
        let matches = try getMatches(for: regex, text: text)
        return matches.map { match in
            getMachingStrings(for: match, regex: regex, text: text, captureGroups: captureGroups)
        }
    }

    // MARK: - Private -

    private static func getMachingStrings(for match: NSTextCheckingResult, regex: String, text: String, captureGroups: [Int]) -> CombinedResult {
        let results = captureGroups
            .compactMap { captureGroup in
                Result(
                    captureGroup: captureGroup,
                    string: Range(match.range(at: captureGroup), in: text).map({String(text[$0])})!,
                    range: Range(match.range(at: captureGroup), in: text)!,
                    regex: regex,
                    text: text
                )
            }
        return CombinedResult(results: results)
    }

    private static func getMatches(for regex: String, text: String) throws -> [NSTextCheckingResult] {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        return regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
    }

}
