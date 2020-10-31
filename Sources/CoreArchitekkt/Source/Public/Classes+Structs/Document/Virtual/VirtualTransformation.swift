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
}
