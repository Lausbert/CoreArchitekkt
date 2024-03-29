// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public enum FirstOrderVirtualTransformation: Hashable, Codable {
    
    // MARK: - Public -
    
    case unfoldNode(id: UUID)
    case hideNode(id: UUID)
    case flattenNode(id: UUID)
    case fixNode(id: UUID)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .unfoldNode:
            let uuid = try container.decode(UUID.self, forKey: .unfoldNode)
            self = .unfoldNode(id: uuid)
        case .hideNode:
            let uuid = try container.decode(UUID.self, forKey: .hideNode)
            self = .hideNode(id: uuid)
        case .flattenNode:
            let uuid = try container.decode(UUID.self, forKey: .flattenNode)
            self = .flattenNode(id: uuid)
        case .fixNode:
            let uuid = try container.decode(UUID.self, forKey: .fixNode)
            self = .fixNode(id: uuid)
        case .none:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .unfoldNode(id: uuid):
            try container.encode(uuid, forKey: .unfoldNode)
        case let .hideNode(id: uuid):
            try container.encode(uuid, forKey: .hideNode)
        case let .flattenNode(id: uuid):
            try container.encode(uuid, forKey: .flattenNode)
        case let .fixNode(id: uuid):
            try container.encode(uuid, forKey: .fixNode)
        }
    }
        
    static func createFirstOrderVirtualTransformations(from node: Node, and secondOrderVirtualTransformations: Set<SecondOrderVirtualTransformation>) -> Set<FirstOrderVirtualTransformation> {
        let transformationContext = SecondOrderVirtualTransformation.Context(
            identifier: node.id,
            transformations: secondOrderVirtualTransformations
        )
        if let firstOrderVirtualTransformations = virtualTransformationCache[transformationContext] {
            return firstOrderVirtualTransformations
        }
        var firstOrderVirtualTransformations: Set<FirstOrderVirtualTransformation> = []
        var newSecondOrderVirtualTransformations: Set<SecondOrderVirtualTransformation> = []
        for transformation in secondOrderVirtualTransformations {
            switch transformation {
            case let .unfoldNode(id):
                firstOrderVirtualTransformations.insert(.unfoldNode(id: id))
            case let .hideNode(id):
                firstOrderVirtualTransformations.insert(.hideNode(id: id))
            case let .flattenNode(id):
                firstOrderVirtualTransformations.insert(.flattenNode(id: id))
            case let .fixNode(id):
                firstOrderVirtualTransformations.insert(.fixNode(id: id))
            default:
                newSecondOrderVirtualTransformations.insert(transformation)
            }
        }
        var result = firstOrderVirtualTransformations
        for transformation in newSecondOrderVirtualTransformations {
            result = result.union(createFirstOrderVirtualTransformations(from: node, secondOrderVirtualTransformation: transformation))
        }
        virtualTransformationCache[transformationContext] = result
        return result
    }
    
    // MARK: - Internal -
    
    struct Context: Hashable {
        let identifier: UUID
        let transformations: Set<FirstOrderVirtualTransformation>
    }
    
    // MARK: - Private -
    
    private static var virtualTransformationCache: [SecondOrderVirtualTransformation.Context: Set<FirstOrderVirtualTransformation>] = [:]
    
    private enum CodingKeys: CodingKey {
        case unfoldNode
        case hideNode
        case flattenNode
        case fixNode
    }
    
    private static func createFirstOrderVirtualTransformations(from node: Node, secondOrderVirtualTransformation: SecondOrderVirtualTransformation) -> Set<FirstOrderVirtualTransformation> {
        let transformationContext = SecondOrderVirtualTransformation.Context(
            identifier: node.id,
            transformations: [secondOrderVirtualTransformation]
        )
        if let firstOrderVirtualTransformations = virtualTransformationCache[transformationContext] {
            return firstOrderVirtualTransformations
        }
        var firstOrderVirtualTransformations: Set<FirstOrderVirtualTransformation> = []
        switch secondOrderVirtualTransformation {
        case let .unfoldScope(scope):
            if scope == node.scope {
                firstOrderVirtualTransformations = [.unfoldNode(id: node.id)]
            }
        case let .hideScope(scope):
            if scope == node.scope {
                firstOrderVirtualTransformations = [.hideNode(id: node.id)]
            }
        case let .flattenScope(scope):
            if scope == node.scope {
                firstOrderVirtualTransformations = [.flattenNode(id: node.id)]
            }
        case let .unfoldNodes(regex):
            if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {
                firstOrderVirtualTransformations = [.unfoldNode(id: node.id)]
            }
        case let .hideNodes(regex):
            if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {
                firstOrderVirtualTransformations = [.hideNode(id: node.id)]
            }
        case let .flattenNodes(regex):
            if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {
                firstOrderVirtualTransformations = [.flattenNode(id: node.id)]
            }
        case let .unfoldScopes(regex):
            if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                firstOrderVirtualTransformations = [.unfoldNode(id: node.id)]
            }
        case let .hideScopes(regex):
            if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                firstOrderVirtualTransformations = [.hideNode(id: node.id)]
            }
        case let .flattenScopes(regex):
            if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                firstOrderVirtualTransformations = [.flattenNode(id: node.id)]
            }
        default:
            assertionFailure()
        }
        let result = firstOrderVirtualTransformations.union(createFirstOrderVirtualTransformations(from: node.children, and: secondOrderVirtualTransformation))
        virtualTransformationCache[transformationContext] = result
        return result
    }
    
    private static func createFirstOrderVirtualTransformations(from nodes: [Node], and secondOrderVirtualTransformation: SecondOrderVirtualTransformation) -> Set<FirstOrderVirtualTransformation> {
        var firstOrderVirtualTransformations: Set<FirstOrderVirtualTransformation> = []
        for node in nodes {
            firstOrderVirtualTransformations = firstOrderVirtualTransformations.union(createFirstOrderVirtualTransformations(from: node, secondOrderVirtualTransformation: secondOrderVirtualTransformation))
        }
        return firstOrderVirtualTransformations
    }
    
}

public enum SecondOrderVirtualTransformation: Hashable, Codable {

    // MARK: - Public -

    case unfoldNode(id: UUID)
    case hideNode(id: UUID)
    case flattenNode(id: UUID)
    case fixNode(id: UUID)
    case unfoldScope(scope: String)
    case hideScope(scope: String)
    case flattenScope(scope: String)
    case unfoldNodes(regex: String)
    case hideNodes(regex: String)
    case flattenNodes(regex: String)
    case unfoldScopes(regex: String)
    case hideScopes(regex: String)
    case flattenScopes(regex: String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .unfoldNode:
            let uuid = try container.decode(UUID.self, forKey: .unfoldNode)
            self = .unfoldNode(id: uuid)
        case .hideNode:
            let uuid = try container.decode(UUID.self, forKey: .hideNode)
            self = .hideNode(id: uuid)
        case .flattenNode:
            let uuid = try container.decode(UUID.self, forKey: .flattenNode)
            self = .flattenNode(id: uuid)
        case .fixNode:
            let uuid = try container.decode(UUID.self, forKey: .fixNode)
            self = .fixNode(id: uuid)
        case .unfoldScope:
            let scope = try container.decode(String.self, forKey: .unfoldScope)
            self = .unfoldScope(scope: scope)
        case .hideScope:
            let scope = try container.decode(String.self, forKey: .hideScope)
            self = .hideScope(scope: scope)
        case .flattenScope:
            let scope = try container.decode(String.self, forKey: .flattenScope)
            self = .flattenScope(scope: scope)
        case .unfoldNodes:
            let regex = try container.decode(String.self, forKey: .unfoldNodes)
            self = .unfoldNodes(regex: regex)
        case .hideNodes:
            let regex = try container.decode(String.self, forKey: .hideNodes)
            self = .hideNodes(regex: regex)
        case .flattenNodes:
            let regex = try container.decode(String.self, forKey: .flattenNodes)
            self = .flattenNodes(regex: regex)
        case .unfoldScopes:
            let regex = try container.decode(String.self, forKey: .unfoldScopes)
            self = .unfoldScopes(regex: regex)
        case .hideScopes:
            let regex = try container.decode(String.self, forKey: .hideScopes)
            self = .hideScopes(regex: regex)
        case .flattenScopes:
            let regex = try container.decode(String.self, forKey: .flattenScopes)
            self = .flattenScopes(regex: regex)
        case .none:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .unfoldNode(id: uuid):
            try container.encode(uuid, forKey: .unfoldNode)
        case let .hideNode(id: uuid):
            try container.encode(uuid, forKey: .hideNode)
        case let .flattenNode(id: uuid):
            try container.encode(uuid, forKey: .flattenNode)
        case let .fixNode(id: uuid):
            try container.encode(uuid, forKey: .fixNode)
        case let .unfoldScope(scope: scope):
            try container.encode(scope, forKey: .unfoldScope)
        case let .hideScope(scope: scope):
            try container.encode(scope, forKey: .hideScope)
        case let .flattenScope(scope: scope):
            try container.encode(scope, forKey: .flattenScope)
        case let .unfoldNodes(regex: regex):
            try container.encode(regex, forKey: .unfoldNodes)
        case let .hideNodes(regex: regex):
            try container.encode(regex, forKey: .hideNodes)
        case let .flattenNodes(regex: regex):
            try container.encode(regex, forKey: .flattenNodes)
        case let .unfoldScopes(regex: regex):
            try container.encode(regex, forKey: .unfoldScopes)
        case let .hideScopes(regex: regex):
            try container.encode(regex, forKey: .hideScopes)
        case let .flattenScopes(regex: regex):
            try container.encode(regex, forKey: .flattenScopes)
        }
    }
    
    // MARK: - Internal -
    
    struct Context: Hashable {
        let identifier: UUID
        let transformations: Set<SecondOrderVirtualTransformation>
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: CodingKey {
        case unfoldNode
        case hideNode
        case flattenNode
        case fixNode
        case unfoldScope
        case hideScope
        case flattenScope
        case unfoldNodes
        case hideNodes
        case flattenNodes
        case unfoldScopes
        case hideScopes
        case flattenScopes
    }
}
