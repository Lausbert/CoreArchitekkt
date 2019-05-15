//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class Node: NSObject, Codable {

    // MARK: - Public -

    public let isRoot: Bool
    public private(set) var identifier: String?
    public private(set) var scope: String
    // for cleaner encoded nodes _children, _arcs and _tags should be optional; for cleaner API children, arcs and tags should not
    public var children: [Node] {
        return _children ?? []
    }
    public var arcs: [Node] {
        return _arcs ?? []
    }
    public var tags: Set<String> {
        return _tags ?? []
    }
    public private(set) weak var parent: Node?
    public var allDescendants: [Node] {
        guard !children.isEmpty else { return [] }
        return children + children.flatMap { $0.allDescendants }
    }

    public init(identifier: String?, scope: String, isRoot: Bool) {
        self.identifier = identifier
        self.scope = scope
        self.isRoot = isRoot
    }

    public convenience init(scope: String, isRoot: Bool) {
        self.init(identifier: nil, scope: scope, isRoot: isRoot)
    }

    public convenience init(identifier: String, scope: String) {
        self.init(identifier: identifier, scope: scope, isRoot: false)
    }

    public convenience init(scope: String) {
        self.init(identifier: nil, scope: scope, isRoot: false)
    }

    public func set(identifier: String) {
        self.identifier = identifier
    }

    public func set(scope: String) {
        self.scope = scope
    }

    public func add(child: Node) {
        if _children == nil {
            _children = []
        }
        _children?.append(child)
        child.parent = self
    }

    public func set(children: [Node]) {
        self._children = children
    }
    
    public func set(arcs: [Node]) {
        self._arcs = arcs
    }

    public func add(arc: Node) {
        // no node should have more than one arc to the same other node
        guard !arcs.contains(arc) else { return }

        // no node should reference itself within _arcs
        guard arc != self else { return }

        // no node should reference its parents within _arcs
        var node = self
        while let parent = node.parent {
            if parent == arc { return }
            node = parent
        }

        if _arcs == nil {
            _arcs = []
        }
        _arcs?.append(arc)
    }

    public func add(tag: String) {
        if _tags == nil {
            _tags = []
        }
        _tags?.insert(tag)
    }

    // MARK: Codable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isRoot, forKey: .isRoot)
        if let identifier = identifier {
            try container.encode(identifier, forKey: .identifier)
        }
        try container.encode(scope, forKey: .scope)
        if let children = _children, !children.isEmpty {
            try container.encode(children, forKey: .children)
        }
        // reinitialize nodes in _arcs without children and arcs to avoid circular dependencies
        if let arcs = _arcs?.map({ Node(identifier: $0.identifier, scope: $0.scope, isRoot: $0.isRoot) }), !arcs.isEmpty {
            try container.encode(arcs, forKey: .arcs)
        }
        if let tags = _tags {
            #if DEBUG
            try container.encode(tags.sorted(), forKey: .tags)
            #else
            try container.encode(tags, forKey: .tags)
            #endif
        }
    }

    /// A decoder for the root node. The initialization will not produce any meaningful results for any other node than the root node. The root node contains the graph as its children. Only nodes that are no children of any other node than the root node are directly contained in a graph. Every other note is contained in exactly one children array of another node. Additionally any node could be contained in any number of arc arrays of any other node, if this node is neither an ancestor nor a descendant.
    ///
    /// - Parameter decoder: A decoder
    /// - Throws: This function throws
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isRoot = try container.decode(Bool.self, forKey: .isRoot)
        identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
        scope = try container.decode(String.self, forKey: .scope)
        _children = try container.decodeIfPresent([Node].self, forKey: .children)
        _arcs = try container.decodeIfPresent([Node].self, forKey: .arcs)
        _tags = try container.decodeIfPresent(Set<String>.self, forKey: .tags)

        super.init()

        _children?.forEach { $0.parent = self }

        if isRoot {
            guard identifier == nil && _arcs == nil else { throw ErrorEnum.unexpectedIdentifierOrArcsForRootNode }
            let namedDescendants = Dictionary(uniqueKeysWithValues: allDescendants.compactMap { (node: Node) -> (String, Node)? in
                if let identifier = node.identifier {
                    return (identifier, node)
                }
                return nil
            })
            try replaceAllNamedArcs(with: namedDescendants)
        }
    }

    // MARK: - Internal -

    enum ErrorEnum: LocalizedError, Equatable {
        case unexpectedIdentifierOrArcsForRootNode
        case unexpectedUnnamedArc
        case unexpectedOrphanedArc

        var errorDescription: String? {
            switch self {
            case .unexpectedIdentifierOrArcsForRootNode:
                return "Unexpected identifier or arcs for root node."
            case .unexpectedUnnamedArc:
                return "Unexpected unnamed arc."
            case .unexpectedOrphanedArc:
                return "Unexpected orphaned arc."
            }
        }
    }

    // MARK: - Private -

    private var _children: [Node]?
    private var _arcs: [Node]?
    private var _tags: Set<String>?

    // MARK: Codable

    private enum CodingKeys: CodingKey {
        case isRoot
        case identifier
        case scope
        case children
        case arcs
        case tags
        // parent is missing on purpose to avoid circular dependencies during encoding
    }

    private func replaceAllNamedArcs(with namedDescendants: [String: Node]) throws {
        for arc in arcs {
            guard let identifier = arc.identifier else { throw ErrorEnum.unexpectedUnnamedArc }
            guard let namedNode = namedDescendants[identifier] else { throw ErrorEnum.unexpectedOrphanedArc }
            replace(arc: arc, with: namedNode)
        }
        try children.forEach { try $0.replaceAllNamedArcs(with: namedDescendants) }
    }

    private func replace(arc: Node, with namedNode: Node) {
        if let index = _arcs?.firstIndex(of: arc) {
            _arcs?[index] = namedNode
        }
    }

}
