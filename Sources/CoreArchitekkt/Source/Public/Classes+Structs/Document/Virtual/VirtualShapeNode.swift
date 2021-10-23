// Copyright © 2020 Stephan Lerner. All rights reserved.

import AppKit

public struct VirtualShapeNode: Identifiable, Equatable {

    // MARK: - Public -

    public let id: UUID
    public let scope: String
    public let name: String?
    public let children: [VirtualShapeNode]
    public let radius: CGFloat
    public let ingoingArcsWeight: Int
    public let outgoingArcsWeight: Int
    public let isFixed: Bool
    
    public static func align(newVirtualShapeNodes: [VirtualShapeNode], with oldVirtualShapeNodes: [VirtualShapeNode]) -> [VirtualShapeNode] {
        var newVirtualShapeNodesDictionary = Dictionary(uniqueKeysWithValues: newVirtualShapeNodes.map {($0.id, $0)} )
        var newVirtualShapeNodes: [VirtualShapeNode] = []
        for oldVirtualShapeNode in oldVirtualShapeNodes {
            if let newVirtualShapeNode = newVirtualShapeNodesDictionary.removeValue(forKey: oldVirtualShapeNode.id) {
                let children = align(newVirtualShapeNodes: newVirtualShapeNode.children, with: oldVirtualShapeNode.children)
                newVirtualShapeNodes.append(
                    VirtualShapeNode(
                        id: newVirtualShapeNode.id,
                        scope: newVirtualShapeNode.scope,
                        name: newVirtualShapeNode.name,
                        children: children,
                        radius: newVirtualShapeNode.radius,
                        ingoingArcsWeight: newVirtualShapeNode.ingoingArcsWeight,
                        outgoingArcsWeight: newVirtualShapeNode.outgoingArcsWeight,
                        isFixed: newVirtualShapeNode.isFixed
                    )
                )
            }
        }
        newVirtualShapeNodes.append(contentsOf: newVirtualShapeNodesDictionary.values)
        return newVirtualShapeNodes
    }

    public static func createVirtualShapeNodes(from node: Node, with transformations: Set<FirstOrderVirtualTransformation>, and virtualArcNodes: [VirtualArcNode]) -> [VirtualShapeNode] {
        let transformationContext = FirstOrderVirtualTransformation.Context(
            identifier: node.id,
            transformations: transformations
        )
        if let virtualShapeNodes = virtualShapeNodesCache[transformationContext] {
            return virtualShapeNodes
        }
        let arcCount = ArcCount(
            ingoingDictionary: Dictionary(virtualArcNodes.map { ($0.destinationIdentifier, $0.weight) }, uniquingKeysWith: { $0 + $1 } ),
            outgoingDictionary: Dictionary(virtualArcNodes.map { ($0.sourceIdentifier, $0.weight) }, uniquingKeysWith: { $0 + $1 } )
        )
        let virtualShapeNodes = createVirtualShapeNodes(from: node, with: transformations, and: arcCount)
        virtualShapeNodesCache[transformationContext] = virtualShapeNodes
        return virtualShapeNodes
    }
    
    public static func radius(for children: [VirtualShapeNode]) -> CGFloat {
        max(1, sqrt(4*children.map {$0.radius^^2} .reduce(0, +)))
    }
    
    // MARK: - Private -
    
    private struct ArcCount {
        let ingoingDictionary: [UUID: Int]
        let outgoingDictionary: [UUID: Int]
    }
    
    private static var virtualShapeNodesCache: [FirstOrderVirtualTransformation.Context: [VirtualShapeNode]] = [:]
        
    private static func createVirtualShapeNodes(from node: Node, with transformations: Set<FirstOrderVirtualTransformation>, and arcCount: ArcCount) -> [VirtualShapeNode] {
        let isFixed = transformations.contains(.fixNode(id: node.id))
        if transformations.contains(.hideNode(id: node.id)) {
            return []
        } else if transformations.contains(.flattenNode(id: node.id)) {
            return node.children.flatMap { createVirtualShapeNodes(from: $0, with: transformations, and: arcCount) }
        } else if transformations.contains(.unfoldNode(id: node.id)) {
            let childrenVirtualShapeNodes = node.children.flatMap { createVirtualShapeNodes(from: $0, with: transformations, and: arcCount) }
            let r = radius(for: childrenVirtualShapeNodes)
            return [
                VirtualShapeNode(
                    id: node.id,
                    scope: node.scope,
                    name: node.name,
                    children: childrenVirtualShapeNodes,
                    radius: r,
                    ingoingArcsWeight: arcCount.ingoingDictionary[node.id, default: 0],
                    outgoingArcsWeight: arcCount.outgoingDictionary[node.id, default: 0],
                    isFixed: isFixed
                )
            ]
        } else {
            let resultingTransformations = transformations.filter {
                if case .unfoldNode = $0 {
                    return false
                } else {
                    return true
                }
            }
            let transformationContext = FirstOrderVirtualTransformation.Context(
                identifier: node.id,
                transformations: resultingTransformations
            )
            if let virtualShapeNodes = virtualShapeNodesCache[transformationContext] {
                return virtualShapeNodes
            }
            let virtualShapeNodes = [
                VirtualShapeNode(
                    id: node.id,
                    scope: node.scope,
                    name: node.name,
                    children: [],
                    radius: 1,
                    ingoingArcsWeight: arcCount.ingoingDictionary[node.id, default: 0],
                    outgoingArcsWeight: arcCount.outgoingDictionary[node.id, default: 0],
                    isFixed: isFixed
                )
            ]
            virtualShapeNodesCache[transformationContext] = virtualShapeNodes
            return virtualShapeNodes
        }
    }

}

extension VirtualShapeNode: CustomStringConvertible {

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
