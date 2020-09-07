// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

enum VirtualTransformation: Hashable, Codable {

    // MARK: - Internal -

    case unfoldNode(id: UUID)
    case hideNode(id: UUID)
    case flattenNode(id: UUID)
    case unfoldScope(scope: String)
    case hideScope(scope: String)
    case flattenScope(scope: String)

    enum CodingKeys: CodingKey {
        case unfoldNode
        case hideNode
        case flattenNode
        case unfoldScope
        case hideScope
        case flattenScope
    }

    init(from decoder: Decoder) throws {
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
        case .unfoldScope:
            let scope = try container.decode(String.self, forKey: .unfoldScope)
            self = .unfoldScope(scope: scope)
        case .hideScope:
            let scope = try container.decode(String.self, forKey: .hideScope)
            self = .hideScope(scope: scope)
        case .flattenScope:
            let scope = try container.decode(String.self, forKey: .flattenScope)
            self = .flattenScope(scope: scope)
        case .none:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .unfoldNode(id: uuid):
            try container.encode(uuid, forKey: .unfoldNode)
        case let .hideNode(id: uuid):
            try container.encode(uuid, forKey: .hideNode)
        case let .flattenNode(id: uuid):
            try container.encode(uuid, forKey: .flattenNode)
        case let .unfoldScope(scope: scope):
            try container.encode(scope, forKey: .unfoldScope)
        case let .hideScope(scope: scope):
            try container.encode(scope, forKey: .hideScope)
        case let .flattenScope(scope: scope):
            try container.encode(scope, forKey: .flattenScope)
        }
    }
}
