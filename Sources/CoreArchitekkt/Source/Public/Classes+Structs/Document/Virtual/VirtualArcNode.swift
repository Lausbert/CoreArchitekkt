// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public struct VirtualArcNode: Hashable {

    // MARK: - Public -

    public let sourceIdentifier: UUID
    public let destinationIdentifier: UUID
    public let weight: Int

    public static func createVirtualArcNodes(from node: Node, with transformations: Set<FirstOrderVirtualTransformation>) -> [VirtualArcNode] {
        var resultingTransformations: Set<FirstOrderVirtualTransformation> = []
        for transformation in transformations {
            switch transformation {
            case .fixNode:
                break // has no influence on arcs
            default:
                resultingTransformations.insert(transformation)
            }
        }
        let transformationContext = FirstOrderVirtualTransformation.Context(
            identifier: node.id,
            transformations: resultingTransformations
        )
        if let virtualArcNodes = virtualArcNodesCache[transformationContext] {
            return virtualArcNodes
        }
        let virtualArcNodeContext = createVirtualArcNodeContext(
            from: node,
            with: resultingTransformations
        )
        var weightDictionary = virtualArcNodeContext.weightDictionary
        weightDictionary.forEach { (weightLessVirtualArcNode, weight) in
            guard !virtualArcNodeContext.hiddenIds.contains(weightLessVirtualArcNode.destinationIdentifier)  else {
                weightDictionary.removeValue(forKey: weightLessVirtualArcNode)
                return
            }
            if let newDestination = virtualArcNodeContext.destinationMapping[weightLessVirtualArcNode.destinationIdentifier] {
                let newWeightLessVirtualArcNode = VirtualArcNodeContext.WeightLessVirtualArcNode(
                    sourceIdentifier: weightLessVirtualArcNode.sourceIdentifier,
                    destinationIdentifier: newDestination
                )
                weightDictionary[newWeightLessVirtualArcNode] = weightDictionary[newWeightLessVirtualArcNode, default: 0] + weight
                weightDictionary.removeValue(forKey: weightLessVirtualArcNode)
            }
        }
        let virtualArcNodes = weightDictionary.map {
            VirtualArcNode(
                sourceIdentifier: $0.sourceIdentifier,
                destinationIdentifier: $0.destinationIdentifier,
                weight: $1
            )
        }.sorted { (lhs, rhs) -> Bool in
            if lhs.sourceIdentifier != rhs.sourceIdentifier {
                return lhs.sourceIdentifier.uuidString < rhs.sourceIdentifier.uuidString
            } else {
                return lhs.destinationIdentifier.uuidString < rhs.destinationIdentifier.uuidString
            }
        }
        virtualArcNodesCache[transformationContext] = virtualArcNodes
        return virtualArcNodes
    }

    // MARK: - Private -

    private struct VirtualArcNodeContext: Hashable {

        struct WeightLessVirtualArcNode: Hashable {
            let sourceIdentifier: UUID
            let destinationIdentifier: UUID
        }

        let weightDictionary: [WeightLessVirtualArcNode: Int]
        let destinationMapping: [UUID: UUID]
        let foldedIds: Set<UUID>
        let hiddenIds: Set<UUID>

    }

    private static var virtualArcNodesCache: [FirstOrderVirtualTransformation.Context: [VirtualArcNode]] = [:]
    private static var virtualArcNodeContextCache: [FirstOrderVirtualTransformation.Context: VirtualArcNodeContext] = [:]

    private static func createVirtualArcNodeContext(from node: Node, with transformations: Set<FirstOrderVirtualTransformation>, isParentFolded: Bool = false) -> VirtualArcNodeContext {

        let weightDictionary = Dictionary(
            uniqueKeysWithValues: node.arcs.map {
                (
                    VirtualArcNodeContext.WeightLessVirtualArcNode(
                        sourceIdentifier: node.id,
                        destinationIdentifier: $0
                    ),
                    1
                )
            }
        )

        if transformations.contains(.hideNode(id: node.id)) {
            let resultingTransformations = Set(node.children.map { FirstOrderVirtualTransformation.hideNode(id: $0.id) })
            let virtualArcNodeContext = createVirtualArcNodeContext(
                from: node.children,
                with: resultingTransformations
            )
            return VirtualArcNodeContext(
                weightDictionary: [:],
                destinationMapping: [:],
                foldedIds: [],
                hiddenIds: virtualArcNodeContext.hiddenIds.union([node.id])
            )
        } else if transformations.contains(.flattenNode(id: node.id)) {
            let virtualArcNodeContext = createVirtualArcNodeContext(
                from: node.children,
                with: transformations,
                isParentFolded: isParentFolded
            )
            let resultingFoldedIds: Set<UUID>
            let resultingDestinationMapping: [UUID: UUID]
            if isParentFolded {
                resultingFoldedIds = Set(node.children.map { $0.id }).union(virtualArcNodeContext.foldedIds)
                let childrenDestinationMapping = virtualArcNodeContext.destinationMapping.map {($0.key, node.id)}
                let destinationMapping = Dictionary(uniqueKeysWithValues: node.children.map {($0.id, node.id)})
                resultingDestinationMapping = destinationMapping.merging(
                    childrenDestinationMapping,
                    uniquingKeysWith: { $1 }
                )
            } else {
                resultingFoldedIds = virtualArcNodeContext.foldedIds
                resultingDestinationMapping = virtualArcNodeContext.destinationMapping
            }
            return VirtualArcNodeContext(
                weightDictionary: virtualArcNodeContext.weightDictionary,
                destinationMapping: resultingDestinationMapping,
                foldedIds: resultingFoldedIds,
                hiddenIds: virtualArcNodeContext.hiddenIds.union([node.id])
            )
        } else if transformations.contains(.unfoldNode(id: node.id)) {
            let virtualArcNodeContext = createVirtualArcNodeContext(
                from: node.children,
                with: transformations
            )
            return VirtualArcNodeContext(
                weightDictionary: weightDictionary.merging(
                    virtualArcNodeContext.weightDictionary,
                    uniquingKeysWith: { $0 + $1 }
                ),
                destinationMapping: virtualArcNodeContext.destinationMapping,
                foldedIds: virtualArcNodeContext.foldedIds,
                hiddenIds: virtualArcNodeContext.hiddenIds
            )
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
            if let virtualArcNodeContext = virtualArcNodeContextCache[transformationContext] {
                return virtualArcNodeContext
            }
            let virtualArcNodeContext = createVirtualArcNodeContext(
                from: node.children,
                with: resultingTransformations,
                isParentFolded: true
            )
            let foldedIds = Set(node.children.map { $0.id })
            let resultingFoldedIds = foldedIds.union(virtualArcNodeContext.foldedIds)
            var resultingWeightDictionary = weightDictionary
            virtualArcNodeContext.weightDictionary.forEach { (weightLessVirtualArcNode, weight) in
                guard !resultingFoldedIds.contains(weightLessVirtualArcNode.destinationIdentifier) else {
                    return
                }
                let newNeightLessVirtualArcNode = VirtualArcNodeContext.WeightLessVirtualArcNode(
                    sourceIdentifier: node.id,
                    destinationIdentifier: weightLessVirtualArcNode.destinationIdentifier
                )
                resultingWeightDictionary[newNeightLessVirtualArcNode] = resultingWeightDictionary[newNeightLessVirtualArcNode, default: 0] + weight
            }
            let childrenDestinationMapping = virtualArcNodeContext.destinationMapping.map {($0.key, node.id)}
            let destinationMapping = Dictionary(uniqueKeysWithValues: node.children.map {($0.id, node.id)})
            let resultingDestinationMapping = destinationMapping.merging(
                childrenDestinationMapping,
                uniquingKeysWith: { $1 }
            )
            let resultingVirtualArcNodeContext = VirtualArcNodeContext(
                weightDictionary: resultingWeightDictionary,
                destinationMapping: resultingDestinationMapping,
                foldedIds: resultingFoldedIds,
                hiddenIds: virtualArcNodeContext.hiddenIds
            )
            virtualArcNodeContextCache[transformationContext] = resultingVirtualArcNodeContext
            return resultingVirtualArcNodeContext
        }
    }

    private static func createVirtualArcNodeContext(from children: [Node], with transformations: Set<FirstOrderVirtualTransformation>, isParentFolded: Bool = false) -> VirtualArcNodeContext {
        var weightDictionary: [VirtualArcNodeContext.WeightLessVirtualArcNode: Int] = [:]
        var destinationMapping: [UUID: UUID] = [:]
        var foldedIds: Set<UUID> = []
        var hiddenIds: Set<UUID> = []
        children.forEach { child in
            let virtualArcNodeContext = createVirtualArcNodeContext(
                from: child,
                with: transformations,
                isParentFolded: isParentFolded
            )
            weightDictionary = weightDictionary.merging(virtualArcNodeContext.weightDictionary, uniquingKeysWith: { $0 + $1 })
            destinationMapping.merge(virtualArcNodeContext.destinationMapping) { $1 }
            foldedIds = foldedIds.union(virtualArcNodeContext.foldedIds)
            hiddenIds = hiddenIds.union(virtualArcNodeContext.hiddenIds)
        }
        return VirtualArcNodeContext(
            weightDictionary: weightDictionary,
            destinationMapping: destinationMapping,
            foldedIds: foldedIds,
            hiddenIds: hiddenIds
        )
    }

    private init(sourceIdentifier: UUID, destinationIdentifier: UUID, weight: Int) {
        self.sourceIdentifier = sourceIdentifier
        self.destinationIdentifier = destinationIdentifier
        self.weight = weight
    }

}

extension VirtualArcNode: CustomStringConvertible {

    // MARK: - Internal -

    public var description: String {
        """

sourceIdentifier:      \(sourceIdentifier.uuidString)
destinationIdentifier: \(destinationIdentifier.uuidString)
weight:                \(weight)

"""
    }

}
