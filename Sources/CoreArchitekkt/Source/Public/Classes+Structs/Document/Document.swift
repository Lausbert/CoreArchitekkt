// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI
import UniformTypeIdentifiers

public extension UTType {
    static let architekktGraph = UTType(exportedAs: "io.Architekkt.graph")
}

public struct Document: FileDocument, Codable {
    
    // MARK: - Public -
    
    public let id: UUID
    public var settings: Settings
    public private(set) var nodeRequest: NodeRequest
    public private(set) var node: Node
    public private(set) var warnings: [String]
    public var isEditing: Bool
    public private(set) var isNew: Bool
    
    public var firstOrderVirtualTransformations: Set<FirstOrderVirtualTransformation> {
        return FirstOrderVirtualTransformation.createFirstOrderVirtualTransformations(from: node, and: secondOrderVirtualTransformations)
    }
    
    public var secondOrderVirtualTransformations: Set<SecondOrderVirtualTransformation> {
        Set(
            settings.settingsItems.compactMap { settingsItem in
                switch settingsItem.value {
                case let .deletable(virtualTransformation):
                    switch virtualTransformation {
                    case let .unfoldNodes(regex), let .hideNodes(regex), let .flattenNodes(regex), let .unfoldScopes(regex), let .hideScopes(regex), let .flattenScopes(regex):
                        return regex.isEmpty ? nil : virtualTransformation
                    default:
                        return virtualTransformation
                    }
                default:
                    return nil
                }
            }
        )
    }
    
    public init() {
        self.id = UUID()
        self.settings = Settings()
        self.nodeRequest = NodeRequest(url: URL(staticString: "/new/document/do/not/access/this/path"), options: [:])
        self.node = Node(scope: "new")
        self.warnings = []
        self.isEditing = false
        self.isNew = true
    }
    
    mutating public func set(nodeRequest: NodeRequest, node: Node, virtualTransformations: [SecondOrderVirtualTransformation], warnings: [String]) {
        guard isNew else {
            assertionFailure()
            return
        }
        self.nodeRequest = nodeRequest
        self.node = node
        settings.toggle(virtualTransformations: virtualTransformations)
        self.warnings = warnings
        self.isNew = false
    }

    public static var readableContentTypes: [UTType] { [.architekktGraph] }

    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self = try JSONDecoder().decode(Document.self, from: data)
        if settingsAreCorrupted() {
            settings = Settings()
        }
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(settings, forKey: .settings)
        try container.encode(nodeRequest, forKey: .nodeRequest)
        try container.encode(node, forKey: .node)
        try container.encode(warnings, forKey: .warnings)
        try container.encode(false, forKey: .isEditing)
        try container.encode(isNew, forKey: .isNew)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: CodingKey {
        case id, settings, nodeRequest, node, warnings, isEditing, isNew
    }
    
    private var version: Int = 0
    
    private func settingsAreCorrupted() -> Bool {
        let validSettings = Settings()
        if settings.settingsGroups.count != validSettings.settingsGroups.count {
            return true
        }
        for settingsGroups in zip(settings.settingsGroups, validSettings.settingsGroups) {
            if settingsGroups.0.name != settingsGroups.1.name {
                return true
            }
        }
        return false
    }
    
}
