//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class Node: NSObject, Codable, Identifiable {

    // MARK: - Public -

    public let id: UUID
    public private(set) var scope: String
    public private(set) var name: String?
    public private(set) var children: [Node]
    public private(set) var arcs: [UUID]
    public private(set) var tags: Set<String>
    public private(set) weak var parent: Node?
    public var allDescendants: [Node] {
        return children + children.flatMap { $0.allDescendants }
    }

    public init(scope: String, name: String? = nil) {
        self.id = UUID()
        self.name = name
        self.scope = scope
        self.children = []
        self.arcs = []
        self.tags = []
    }

    public func set(scope: String) {
        self.scope = scope
    }

    public func set(name: String) {
        self.name = name
    }

    public func add(child: Node) {
        children.append(child)
        child.parent = self
    }

    public func set(children: [Node]) {
        self.children = children
        children.forEach { $0.parent = self }
    }

    public func set(arcs: [UUID]) {
        self.arcs = []
        arcs.forEach { add(arc: $0) }
    }

    public func add(arc: UUID) {
        // no node should have more than one arc to the same other node
        guard !arcs.contains(arc) else { return }

        // no node should reference itself within _arcs
        guard arc != self.id else { return }

        // no node should reference its parents within _arcs
        var node = self
        while let parent = node.parent {
            if parent.id == arc { return }
            node = parent
        }

        arcs.append(arc)
    }

    public func add(tag: String) {
        tags.insert(tag)
    }

    // MARK: Codable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(scope, forKey: .scope)
        if let name = name {
            try container.encode(name, forKey: .name)
        }
        try container.encode(children, forKey: .children)
        try container.encode(arcs, forKey: .arcs)
        try container.encode(tags.sorted(), forKey: .tags)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        scope = try container.decode(String.self, forKey: .scope)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        children = try container.decode([Node].self, forKey: .children)
        arcs = try container.decode([UUID].self, forKey: .arcs)
        tags = try container.decode(Set<String>.self, forKey: .tags)

        super.init()

        children.forEach { $0.parent = self }
    }

    // MARK: - Private -

    private enum CodingKeys: CodingKey {
        case id
        case isRoot
        case scope
        case name
        case children
        case arcs
        case tags
        // parent is missing on purpose to avoid circular dependencies during encoding
    }

}
