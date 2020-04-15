//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class Node: Codable {

    // MARK: - Public -

    public let identifier: String
    public let isRoot: Bool
    public private(set) var scope: String
    public private(set) var name: String?
    public private(set) var children: [Node]
    public private(set) var arcs: [String]
    public private(set) var tags: Set<String>
    public private(set) weak var parent: Node?
    
    public var allDescendants: [Node] {
        guard !children.isEmpty else { return [] }
        return children + children.flatMap { $0.allDescendants }
    }

    public init(scope: String, name: String? = nil, isRoot: Bool = false) {
        self.identifier = UUID().uuidString
        self.isRoot = isRoot
        self.scope = scope
        self.name = name
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

    public func set(arcs: [String]) {
        self.arcs = arcs
    }

    public func add(arc: String) {
        // no node should have more than one arc to the same other node
        guard !arcs.contains(arc) else { return }

        // no node should reference itself or its parents within _arcs
        var node: Node? = self
        while let selfOrAncestor = node {
            if selfOrAncestor.identifier == arc { return }
            node = selfOrAncestor.parent
        }

        arcs.append(identifier)
    }

    public func add(tag: String) {
        tags.insert(tag)
    }

}
