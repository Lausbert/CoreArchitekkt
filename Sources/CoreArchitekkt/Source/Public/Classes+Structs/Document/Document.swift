// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI
import UniformTypeIdentifiers

public extension UTType {
    static let architekktGraph = UTType(exportedAs: "io.Architekkt.graph")
}

public struct Document: FileDocument, Codable {
    
    // MARK: - Public -
    
    public let id: UUID
    public let settings: Settings
    public private(set) var nodeRequest: NodeRequest
    public private(set) var node: Node
    public private(set) var warnings: [String]
    public private(set) var isNew: Bool
    
    public init() {
        self.id = UUID()
        self.settings = Settings()
        self.nodeRequest = NodeRequest(url: URL(staticString: "/new/document/do/not/access/this/path"), options: [:])
        self.node = Node(scope: "new")
        self.warnings = []
        self.isNew = true
    }
    
    mutating public func set(nodeRequest: NodeRequest, node: Node, warnings: [String]) {
        guard isNew else {
            assertionFailure()
            return
        }
        self.nodeRequest = nodeRequest
        self.node = node
        self.warnings = warnings
        self.isNew = false
        self.bumpVersion()
    }
    
    public mutating func bumpVersion() {
        version += 1
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
    
    // MARK: - Private -
    
    private var version: Int = 0
    
}
