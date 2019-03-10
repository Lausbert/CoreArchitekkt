//
//  Shell.swift
//  Nimble
//
//  Created by Stephan Lerner on 27.05.18.
//

import Foundation

public struct Shell {

    // MARK: - Public -

    @discardableResult public static func launch(path: String, arguments: [String]) -> String? {
        let task = Process()
        task.launchPath = path.replacingOccurrences(of: "file://", with: "")
        task.arguments = arguments.map { $0.replacingOccurrences(of: "file://", with: "") }

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)

        return output
    }

}
