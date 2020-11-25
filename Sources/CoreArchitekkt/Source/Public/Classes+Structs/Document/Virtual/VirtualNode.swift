// Copyright © 2020 Stephan Lerner. All rights reserved.

import AppKit

public struct VirtualNode: Identifiable, Equatable {

    // MARK: - Public -

    public let id: UUID
    public let scope: String
    public let name: String?
    public let children: [VirtualNode]
    public let radius: CGFloat
    public let ingoingArcsWeight: Int
    public let outgoingArcsWeight: Int
    
    public static func align(newVirtualNodes: [VirtualNode], with oldVirtualNodes: [VirtualNode]) -> [VirtualNode] {
        var newVirtualNodesDictionary = Dictionary(uniqueKeysWithValues: newVirtualNodes.map {($0.id, $0)} )
        var newVirtualNodes: [VirtualNode] = []
        for oldVirtualNode in oldVirtualNodes {
            if let newVirtualNode = newVirtualNodesDictionary.removeValue(forKey: oldVirtualNode.id) {
                let children = align(newVirtualNodes: newVirtualNode.children, with: oldVirtualNode.children)
                newVirtualNodes.append(
                    VirtualNode(
                        id: newVirtualNode.id,
                        scope: newVirtualNode.scope,
                        name: newVirtualNode.name,
                        children: children,
                        radius: newVirtualNode.radius,
                        ingoingArcsWeight: newVirtualNode.ingoingArcsWeight,
                        outgoingArcsWeight: newVirtualNode.outgoingArcsWeight
                    )
                )
            }
        }
        newVirtualNodes.append(contentsOf: newVirtualNodesDictionary.values)
        return newVirtualNodes
    }

    public static func createVirtualNodes(from node: Node, with transformations: Set<VirtualTransformation>, and virtualArcs: [VirtualArc]) -> [VirtualNode] {
        let arcCount = ArcCount(
            ingoingDictionary: Dictionary(virtualArcs.map { ($0.destinationIdentifier, $0.weight) }, uniquingKeysWith: { $0 + $1 } ),
            outgoingDictionary: Dictionary(virtualArcs.map { ($0.sourceIdentifier, $0.weight) }, uniquingKeysWith: { $0 + $1 } )
        )
        return createVirtualNodes(from: node, with: transformations, and: VirtualTransformation.createRegexEvaluations(from: transformations), and: arcCount)
    }
    
    public static func radius(for children: [VirtualNode]) -> CGFloat {
        max(1, sqrt(4*children.map {$0.radius^^2} .reduce(0, +)))
    }
    
    // MARK: - Private -
    
    private struct ArcCount {
        let ingoingDictionary: [UUID: Int]
        let outgoingDictionary: [UUID: Int]
    }
        
    private static func createVirtualNodes(from node: Node, with transformations: Set<VirtualTransformation>, and regexEvaluations: VirtualTransformation.RegexEvaluations, and arcCount: ArcCount) -> [VirtualNode] {

        if transformations.contains(.hideNode(id: node.id)) || transformations.contains(.hideScope(scope: node.scope)) || regexEvaluations.hideNodesBlock(node) || regexEvaluations.hideScopesBlock(node) {
            return []
        } else if transformations.contains(.flattenNode(id: node.id)) || transformations.contains(.flattenScope(scope: node.scope)) || regexEvaluations.flattenNodesBlock(node) || regexEvaluations.flattenScopesBlock(node) {
            return node.children.flatMap { createVirtualNodes(from: $0, with: transformations, and: regexEvaluations, and: arcCount) }
        } else if transformations.contains(.unfoldNode(id: node.id)) || transformations.contains(.unfoldScope(scope: node.scope)) || regexEvaluations.unfoldNodesBlock(node) || regexEvaluations.unfoldScopesBlock(node) {
            let childrenVirtualNodes = node.children.flatMap { createVirtualNodes(from: $0, with: transformations, and: regexEvaluations, and: arcCount) }
            let r = radius(for: childrenVirtualNodes)
            return[
                VirtualNode(
                    id: node.id,
                    scope: node.scope,
                    name: node.name,
                    children: childrenVirtualNodes,
                    radius: r,
                    ingoingArcsWeight: arcCount.ingoingDictionary[node.id, default: 0],
                    outgoingArcsWeight: arcCount.outgoingDictionary[node.id, default: 0]
                )
            ]
        }

        return [
            VirtualNode(
                id: node.id,
                scope: node.scope,
                name: node.name,
                children: [],
                radius: 1,
                ingoingArcsWeight: arcCount.ingoingDictionary[node.id, default: 0],
                outgoingArcsWeight: arcCount.outgoingDictionary[node.id, default: 0]
            )
        ]
    }

}

extension VirtualNode: CustomStringConvertible {

    // MARK: - Public -

    public var description: String {
        description(forNestingLevel: 0) + "\n"
    }

    // MARK: - Private -

    private func description(forNestingLevel level: Int) -> String {
        let newLine = "\n" + String.init(repeating: "\t", count: level)
        var result = "\(newLine)id: \(id)"
        result += "\(newLine)scope: \(scope)"
        if let name = name {
            result += "\(newLine)name: \(String(describing: name))"
        }
        result += "\(newLine)radius: \(radius)"
        if !children.isEmpty {
            result += "\(newLine)children: ["
            result += "\(children.map({ $0.description(forNestingLevel: level + 1) }).joined(separator: ","))"
            result += "\(newLine)]"
        }
        return result
    }

}
