//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class Node: Codable {

    // MARK: - Public -

    public let identifier: String
    public let isRoot: Bool
    public private(set) var scope: String
    public private(set) var name: String?
    // for cleaner encoded nodes _children, _arcs and _tags should be optional; for cleaner API children, arcs and tags should not
    public var children: [Node] {
        return _children ?? []
    }
    public var arcs: [String] {
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

    public init(scope: String, name: String? = nil, isRoot: Bool = false) {
        self.identifier = UUID().uuidString
        self.scope = scope
        self.name = name
        self.isRoot = isRoot
    }

    public func set(scope: String) {
        self.scope = scope
    }

    public func set(name: String) {
        self.name = name
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

    public func set(arcs: [String]) {
        self._arcs = arcs
    }

    public func add(arc: String) {
        // no node should have more than one arc to the same other node
        guard !arcs.contains(arc) else { return }

        // no node should reference itself within _arcs
        guard arc != self.identifier else { return }

        // no node should reference its parents within _arcs
        var node = self
        while let parent = node.parent {
            if parent.identifier == arc { return }
            node = parent
        }

        if _arcs == nil {
            _arcs = []
        }
        _arcs?.append(identifier)
    }

    public func add(tag: String) {
        if _tags == nil {
            _tags = []
        }
        _tags?.insert(tag)
    }

    // MARK: - Private -

    private var _children: [Node]?
    private var _arcs: [String]?
    private var _tags: Set<String>?

}
