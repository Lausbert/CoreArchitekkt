// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI
import UniformTypeIdentifiers

public extension UTType {
    static let architekktGraph = UTType(exportedAs: "io.Architekkt.graph")
}

public struct Document: FileDocument, Codable {
    
    // MARK: - Public -
    
    public private(set) var node: Node
    public let settings: Settings
    public private(set) var isNew: Bool

    public init(node: Node? = nil) {
        self.node = node ?? Node(scope: "new")
        self.settings = Settings()
        self.isNew = node == nil
    }
    
    mutating public func set(graph: Node) {
        guard isNew else {
            assertionFailure()
            return
        }
        self.node = graph
        self.isNew = false
    }

    public static var readableContentTypes: [UTType] { [.architekktGraph] }

    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = try JSONDecoder().decode(Document.self, from: data)
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}
