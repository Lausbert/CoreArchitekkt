// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public enum VirtualTransformation: Hashable, Codable {

    // MARK: - Public -

    case unfoldNode(id: UUID)
    case unfoldNodes(regex: String)
    case hideNode(id: UUID)
    case hideNodes(regex: String)
    case flattenNode(id: UUID)
    case flattenNodes(regex: String)
    case unfoldScope(scope: String)
    case unfoldScopes(regex: String)
    case hideScope(scope: String)
    case hideScopes(regex: String)
    case flattenScope(scope: String)
    case flattenScopes(regex: String)

    enum CodingKeys: CodingKey {
        case unfoldNode
        case unfoldNodes
        case hideNode
        case hideNodes
        case flattenNode
        case flattenNodes
        case unfoldScope
        case unfoldScopes
        case hideScope
        case hideScopes
        case flattenScope
        case flattenScopes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .unfoldNode:
            let uuid = try container.decode(UUID.self, forKey: .unfoldNode)
            self = .unfoldNode(id: uuid)
        case .unfoldNodes:
            let regex = try container.decode(String.self, forKey: .unfoldNodes)
            self = .unfoldNodes(regex: regex)
        case .hideNode:
            let uuid = try container.decode(UUID.self, forKey: .hideNode)
            self = .hideNode(id: uuid)
        case .hideNodes:
            let regex = try container.decode(String.self, forKey: .hideNodes)
            self = .hideNodes(regex: regex)
        case .flattenNode:
            let uuid = try container.decode(UUID.self, forKey: .flattenNode)
            self = .flattenNode(id: uuid)
        case .flattenNodes:
            let regex = try container.decode(String.self, forKey: .flattenNodes)
            self = .flattenNodes(regex: regex)
        case .unfoldScope:
            let scope = try container.decode(String.self, forKey: .unfoldScope)
            self = .unfoldScope(scope: scope)
        case .unfoldScopes:
            let regex = try container.decode(String.self, forKey: .unfoldScopes)
            self = .unfoldScopes(regex: regex)
        case .hideScope:
            let scope = try container.decode(String.self, forKey: .hideScope)
            self = .hideScope(scope: scope)
        case .hideScopes:
            let regex = try container.decode(String.self, forKey: .hideScopes)
            self = .hideScopes(regex: regex)
        case .flattenScope:
            let scope = try container.decode(String.self, forKey: .flattenScope)
            self = .flattenScope(scope: scope)
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
        case let .unfoldNodes(regex: regex):
            try container.encode(regex, forKey: .unfoldNodes)
        case let .hideNode(id: uuid):
            try container.encode(uuid, forKey: .hideNode)
        case let .hideNodes(regex: regex):
            try container.encode(regex, forKey: .hideNodes)
        case let .flattenNode(id: uuid):
            try container.encode(uuid, forKey: .flattenNode)
        case let .flattenNodes(regex: regex):
            try container.encode(regex, forKey: .flattenNodes)
        case let .unfoldScope(scope: scope):
            try container.encode(scope, forKey: .unfoldScope)
        case let .unfoldScopes(regex: regex):
            try container.encode(regex, forKey: .unfoldScopes)
        case let .hideScope(scope: scope):
            try container.encode(scope, forKey: .hideScope)
        case let .hideScopes(regex: regex):
            try container.encode(regex, forKey: .hideScopes)
        case let .flattenScope(scope: scope):
            try container.encode(scope, forKey: .flattenScope)
        case let .flattenScopes(regex: regex):
            try container.encode(regex, forKey: .flattenScopes)
        }
    }
    
    // MARK: - Internal -
    
    struct RegexEvaluations {
        let hideNodesBlock: (Node) -> Bool
        let flattenNodesBlock: (Node) -> Bool
        let unfoldNodesBlock: (Node) -> Bool
        let hideScopesBlock: (Node) -> Bool
        let flattenScopesBlock: (Node) -> Bool
        let unfoldScopesBlock: (Node) -> Bool
    }
    
    static func createRegexEvaluations(from transformations: Set<VirtualTransformation>) -> RegexEvaluations {
        var hideNodesRegex: [String] = []
        var flattenNodesRegex: [String] = []
        var unfoldNodesRegex: [String] = []
        var hideScopesRegex: [String] = []
        var flattenScopesRegex: [String] = []
        var unfoldScopesRegex: [String] = []
        for transformation in transformations {
            switch transformation {
            case let .hideNodes(regex: regex):
                hideNodesRegex.append(regex)
            case let .flattenNodes(regex: regex):
                flattenNodesRegex.append(regex)
            case let .unfoldNodes(regex: regex):
                unfoldNodesRegex.append(regex)
            case let .hideScopes(regex: regex):
                hideScopesRegex.append(regex)
            case let .flattenScopes(regex: regex):
                flattenScopesRegex.append(regex)
            case let .unfoldScopes(regex: regex):
                unfoldScopesRegex.append(regex)
            default:
                break
            }
        }
        let hideNodesBlock: (Node) -> Bool = { node in
            hideNodesRegex.anySatisfy {
                if let isMatching = try? Regex.isMatching(for: $0, text: node.name?.components(separatedBy: ".").last ?? node.scope) {
                    return isMatching
                } else {
                    return false
                }
            }
        }
        let flattenNodesBlock: (Node) -> Bool = { node in
            flattenNodesRegex.anySatisfy {
                if let isMatching = try? Regex.isMatching(for: $0, text: node.name?.components(separatedBy: ".").last ?? node.scope) {
                    return isMatching
                } else {
                    return false
                }
            }
        }
        let unfoldNodesBlock: (Node) -> Bool = { node in
            unfoldNodesRegex.anySatisfy {
                if let isMatching = try? Regex.isMatching(for: $0, text: node.name?.components(separatedBy: ".").last ?? node.scope) {
                    return isMatching
                } else {
                    return false
                }
            }
        }
        let hideScopesBlock: (Node) -> Bool = { node in
            hideScopesRegex.anySatisfy {
                if let isMatching = try? Regex.isMatching(for: $0, text: node.scope) {
                    return isMatching
                } else {
                    return false
                }
            }
            
        }
        let flattenScopesBlock: (Node) -> Bool = { node in
            flattenScopesRegex.anySatisfy {
                if let isMatching = try? Regex.isMatching(for: $0, text: node.scope) {
                    return isMatching
                } else {
                    return false
                }
            }
        }
        let unfoldScopesBlock: (Node) -> Bool = { node in
            unfoldScopesRegex.anySatisfy {
                if let isMatching = try? Regex.isMatching(for: $0, text: node.scope) {
                    return isMatching
                } else {
                    return false
                }
            }
        }
        return RegexEvaluations(
            hideNodesBlock: hideNodesBlock,
            flattenNodesBlock: flattenNodesBlock,
            unfoldNodesBlock: unfoldNodesBlock,
            hideScopesBlock: hideScopesBlock,
            flattenScopesBlock: flattenScopesBlock,
            unfoldScopesBlock: unfoldScopesBlock
        )
    }
}
