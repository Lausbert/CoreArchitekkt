// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public enum FirstOrderVirtualTransformation: Hashable, Codable {
    
    // MARK: - Public -
    
    case unfoldNode(id: UUID)
    case hideNode(id: UUID)
    case flattenNode(id: UUID)
    case colorNode(id: UUID, color: CodableColor)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .unfoldNode:
            let id = try container.decode(UUID.self, forKey: .unfoldNode)
            self = .unfoldNode(id: id)
        case .hideNode:
            let id = try container.decode(UUID.self, forKey: .hideNode)
            self = .hideNode(id: id)
        case .flattenNode:
            let id = try container.decode(UUID.self, forKey: .flattenNode)
            self = .flattenNode(id: id)
        case .colorNode:
            let (id, color): (UUID, CodableColor) = try container.decodeValues(for: .colorNode)
            self = .colorNode(id: id, color: color)
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
        case let .unfoldNode(id):
            try container.encode(id, forKey: .unfoldNode)
        case let .hideNode(id):
            try container.encode(id, forKey: .hideNode)
        case let .flattenNode(id):
            try container.encode(id, forKey: .flattenNode)
        case let .colorNode(id, color):
            try container.encodeValues(id, color, for: .colorNode)
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
            case let .colorNode(id, color: color):
                firstOrderVirtualTransformations.insert(.colorNode(id: id, color: color))
            default:
                newSecondOrderVirtualTransformations.insert(transformation)
            }
        }
        let result = firstOrderVirtualTransformations.union(createFirstOrderVirtualTransformations(from: node, secondOrderVirtualTransformations: newSecondOrderVirtualTransformations))
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
        case colorNode
    }
    
    private static func createFirstOrderVirtualTransformations(from node: Node, secondOrderVirtualTransformations: Set<SecondOrderVirtualTransformation>) -> Set<FirstOrderVirtualTransformation> {
        let transformationContext = SecondOrderVirtualTransformation.Context(
            identifier: node.id,
            transformations: secondOrderVirtualTransformations
        )
        if let firstOrderVirtualTransformations = virtualTransformationCache[transformationContext] {
            return firstOrderVirtualTransformations
        }
        var firstOrderVirtualTransformations: Set<FirstOrderVirtualTransformation> = []
        for transformation in secondOrderVirtualTransformations {
            switch transformation {
            case let .unfoldScope(scope):
                if scope == node.scope {
                    firstOrderVirtualTransformations.insert(.unfoldNode(id: node.id))
                }
            case let .hideScope(scope):
                if scope == node.scope {
                    firstOrderVirtualTransformations.insert(.hideNode(id: node.id))
                }
            case let .flattenScope(scope):
                if scope == node.scope {
                    firstOrderVirtualTransformations.insert(.flattenNode(id: node.id))
                }
            case let .colorScope(scope, color):
                if scope == node.scope {
                    firstOrderVirtualTransformations.insert(.colorNode(id: node.id, color: color))
                }
            case let .unfoldNodes(regex):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.unfoldNode(id: node.id))
                }
            case let .hideNodes(regex):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {          firstOrderVirtualTransformations.insert(.hideNode(id: node.id))
                }
            case let .flattenNodes(regex):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.flattenNode(id: node.id))
                }
            case let .colorNodes(regex, color):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.name?.components(separatedBy: ".").last ?? node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.colorNode(id: node.id, color: color))
                }
            case let .unfoldScopes(regex):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.unfoldNode(id: node.id))
                }
            case let .hideScopes(regex):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.hideNode(id: node.id))
                }
            case let .flattenScopes(regex):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.flattenNode(id: node.id))
                }
            case let .colorScopes(regex, color):
                if let isMatching = try? Regex.isMatching(for: regex, text: node.scope), isMatching {
                    firstOrderVirtualTransformations.insert(.colorNode(id: node.id, color: color))
                }
            default:
                assertionFailure()
            }
        }
        let result = firstOrderVirtualTransformations.union(createFirstOrderVirtualTransformations(from: node.children, and: secondOrderVirtualTransformations))
        virtualTransformationCache[transformationContext] = result
        return result
    }
    
    private static func createFirstOrderVirtualTransformations(from nodes: [Node], and secondOrderVirtualTransformations: Set<SecondOrderVirtualTransformation>) -> Set<FirstOrderVirtualTransformation> {
        var firstOrderVirtualTransformations: Set<FirstOrderVirtualTransformation> = []
        for node in nodes {
            firstOrderVirtualTransformations = firstOrderVirtualTransformations.union(createFirstOrderVirtualTransformations(from: node, secondOrderVirtualTransformations: secondOrderVirtualTransformations))
        }
        return firstOrderVirtualTransformations
    }
    
}

public enum SecondOrderVirtualTransformation: Hashable, Codable {

    // MARK: - Public -

    case unfoldNode(id: UUID)
    case hideNode(id: UUID)
    case flattenNode(id: UUID)
    case colorNode(id: UUID, color: CodableColor)
    case unfoldScope(scope: String)
    case hideScope(scope: String)
    case flattenScope(scope: String)
    case colorScope(scope: String, color: CodableColor)
    case unfoldNodes(regex: String)
    case hideNodes(regex: String)
    case flattenNodes(regex: String)
    case colorNodes(regex: String, color: CodableColor)
    case unfoldScopes(regex: String)
    case hideScopes(regex: String)
    case flattenScopes(regex: String)
    case colorScopes(regex: String, color: CodableColor)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .unfoldNode:
            let id = try container.decode(UUID.self, forKey: .unfoldNode)
            self = .unfoldNode(id: id)
        case .hideNode:
            let id = try container.decode(UUID.self, forKey: .hideNode)
            self = .hideNode(id: id)
        case .flattenNode:
            let id = try container.decode(UUID.self, forKey: .flattenNode)
            self = .flattenNode(id: id)
        case .colorNode:
            let (id, color): (UUID, CodableColor) = try container.decodeValues(for: .colorNode)
            self = .colorNode(id: id, color: color)
        case .unfoldScope:
            let scope = try container.decode(String.self, forKey: .unfoldScope)
            self = .unfoldScope(scope: scope)
        case .hideScope:
            let scope = try container.decode(String.self, forKey: .hideScope)
            self = .hideScope(scope: scope)
        case .flattenScope:
            let scope = try container.decode(String.self, forKey: .flattenScope)
            self = .flattenScope(scope: scope)
        case .colorScope:
            let (scope, color): (String, CodableColor) = try container.decodeValues(for: .colorScope)
            self = .colorScope(scope: scope, color: color)
        case .unfoldNodes:
            let regex = try container.decode(String.self, forKey: .unfoldNodes)
            self = .unfoldNodes(regex: regex)
        case .hideNodes:
            let regex = try container.decode(String.self, forKey: .hideNodes)
            self = .hideNodes(regex: regex)
        case .flattenNodes:
            let regex = try container.decode(String.self, forKey: .flattenNodes)
            self = .flattenNodes(regex: regex)
        case .colorNodes:
            let (regex, color): (String, CodableColor) = try container.decodeValues(for: .colorNodes)
            self = .colorNodes(regex: regex, color: color)
        case .unfoldScopes:
            let regex = try container.decode(String.self, forKey: .unfoldScopes)
            self = .unfoldScopes(regex: regex)
        case .hideScopes:
            let regex = try container.decode(String.self, forKey: .hideScopes)
            self = .hideScopes(regex: regex)
        case .flattenScopes:
            let regex = try container.decode(String.self, forKey: .flattenScopes)
            self = .flattenScopes(regex: regex)
        case .colorScopes:
            let (regex, color): (String, CodableColor) = try container.decodeValues(for: .colorScopes)
            self = .colorScopes(regex: regex, color: color)
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
        case let .unfoldNode(id):
            try container.encode(id, forKey: .unfoldNode)
        case let .hideNode(id):
            try container.encode(id, forKey: .hideNode)
        case let .flattenNode(id):
            try container.encode(id, forKey: .flattenNode)
        case let .colorNode(id, color):
            try container.encodeValues(id, color, for: .colorNode)
        case let .unfoldScope(scope: scope):
            try container.encode(scope, forKey: .unfoldScope)
        case let .hideScope(scope: scope):
            try container.encode(scope, forKey: .hideScope)
        case let .flattenScope(scope: scope):
            try container.encode(scope, forKey: .flattenScope)
        case let .colorScope(scope, color):
            try container.encodeValues(scope, color, for: .colorScope)
        case let .unfoldNodes(regex: regex):
            try container.encode(regex, forKey: .unfoldNodes)
        case let .hideNodes(regex: regex):
            try container.encode(regex, forKey: .hideNodes)
        case let .flattenNodes(regex: regex):
            try container.encode(regex, forKey: .flattenNodes)
        case let .colorNodes(regex, color):
            try container.encodeValues(regex, color, for: .colorNodes)
        case let .unfoldScopes(regex: regex):
            try container.encode(regex, forKey: .unfoldScopes)
        case let .hideScopes(regex: regex):
            try container.encode(regex, forKey: .hideScopes)
        case let .flattenScopes(regex: regex):
            try container.encode(regex, forKey: .flattenScopes)
        case let .colorScopes(regex, color):
            try container.encodeValues(regex, color, for: .colorScopes)
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
        case colorNode
        case unfoldScope
        case hideScope
        case flattenScope
        case colorScope
        case unfoldNodes
        case hideNodes
        case flattenNodes
        case colorNodes
        case unfoldScopes
        case hideScopes
        case flattenScopes
        case colorScopes
    }
}
