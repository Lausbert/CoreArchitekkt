// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public struct VirtualArc: Hashable {

    // MARK: - Public -

    public let sourceIdentifier: UUID
    public let destinationIdentifier: UUID
    public let weight: Int

    public static func createVirtualArcs(from node: Node, with transformations: Set<FirstOrderVirtualTransformation>) -> [VirtualArc] {
        let resultingTransformations = transformations.filter {
            if case .colorNode = $0 {
                return false
            } else {
                return true
            }
        }
        let transformationContext = FirstOrderVirtualTransformation.Context(
            identifier: node.id,
            transformations: resultingTransformations
        )
        if let virtualArcs = virtualArcsCache[transformationContext] {
            return virtualArcs
        }
        let virtualArcContext = createVirtualArcContext(
            from: node,
            with: resultingTransformations
        )
        var weightDictionary = virtualArcContext.weightDictionary
        weightDictionary.forEach { (weightLessVirtualArc, weight) in
            guard !virtualArcContext.hiddenIds.contains(weightLessVirtualArc.destinationIdentifier)  else {
                weightDictionary.removeValue(forKey: weightLessVirtualArc)
                return
            }
            if let newDestination = virtualArcContext.destinationMapping[weightLessVirtualArc.destinationIdentifier] {
                let newWeightLessVirtualArc = VirtualArcContext.WeightLessVirtualArc(
                    sourceIdentifier: weightLessVirtualArc.sourceIdentifier,
                    destinationIdentifier: newDestination
                )
                weightDictionary[newWeightLessVirtualArc] = weightDictionary[newWeightLessVirtualArc, default: 0] + weight
                weightDictionary.removeValue(forKey: weightLessVirtualArc)
            }
        }
        let virtualArcs = weightDictionary.map {
            VirtualArc(
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
        virtualArcsCache[transformationContext] = virtualArcs
        return virtualArcs
    }

    // MARK: - Private -

    private struct VirtualArcContext: Hashable {

        struct WeightLessVirtualArc: Hashable {
            let sourceIdentifier: UUID
            let destinationIdentifier: UUID
        }

        let weightDictionary: [WeightLessVirtualArc: Int]
        let destinationMapping: [UUID: UUID]
        let foldedIds: Set<UUID>
        let hiddenIds: Set<UUID>

    }

    private static var virtualArcsCache: [FirstOrderVirtualTransformation.Context: [VirtualArc]] = [:]
    private static var virtualArcContextCache: [FirstOrderVirtualTransformation.Context: VirtualArcContext] = [:]

    private static func createVirtualArcContext(from node: Node, with transformations: Set<FirstOrderVirtualTransformation>, isParentFolded: Bool = false) -> VirtualArcContext {

        let weightDictionary = Dictionary(
            uniqueKeysWithValues: node.arcs.map {
                (
                    VirtualArcContext.WeightLessVirtualArc(
                        sourceIdentifier: node.id,
                        destinationIdentifier: $0
                    ),
                    1
                )
            }
        )

        if transformations.contains(.hideNode(id: node.id)) {
            let resultingTransformations = Set(node.children.map { FirstOrderVirtualTransformation.hideNode(id: $0.id) })
            let virtualArcContext = createVirtualArcContext(
                from: node.children,
                with: resultingTransformations
            )
            return VirtualArcContext(
                weightDictionary: [:],
                destinationMapping: [:],
                foldedIds: [],
                hiddenIds: virtualArcContext.hiddenIds.union([node.id])
            )
        } else if transformations.contains(.flattenNode(id: node.id)) {
            let virtualArcContext = createVirtualArcContext(
                from: node.children,
                with: transformations,
                isParentFolded: isParentFolded
            )
            let resultingFoldedIds: Set<UUID>
            let resultingDestinationMapping: [UUID: UUID]
            if isParentFolded {
                resultingFoldedIds = Set(node.children.map { $0.id }).union(virtualArcContext.foldedIds)
                let childrenDestinationMapping = virtualArcContext.destinationMapping.map {($0.key, node.id)}
                let destinationMapping = Dictionary(uniqueKeysWithValues: node.children.map {($0.id, node.id)})
                resultingDestinationMapping = destinationMapping.merging(
                    childrenDestinationMapping,
                    uniquingKeysWith: { $1 }
                )
            } else {
                resultingFoldedIds = virtualArcContext.foldedIds
                resultingDestinationMapping = virtualArcContext.destinationMapping
            }
            return VirtualArcContext(
                weightDictionary: virtualArcContext.weightDictionary,
                destinationMapping: resultingDestinationMapping,
                foldedIds: resultingFoldedIds,
                hiddenIds: virtualArcContext.hiddenIds.union([node.id])
            )
        } else if transformations.contains(.unfoldNode(id: node.id)) {
            let virtualArcContext = createVirtualArcContext(
                from: node.children,
                with: transformations
            )
            return VirtualArcContext(
                weightDictionary: weightDictionary.merging(
                    virtualArcContext.weightDictionary,
                    uniquingKeysWith: { $0 + $1 }
                ),
                destinationMapping: virtualArcContext.destinationMapping,
                foldedIds: virtualArcContext.foldedIds,
                hiddenIds: virtualArcContext.hiddenIds
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
            if let virtualArcContext = virtualArcContextCache[transformationContext] {
                return virtualArcContext
            }
            let virtualArcContext = createVirtualArcContext(
                from: node.children,
                with: resultingTransformations,
                isParentFolded: true
            )
            let foldedIds = Set(node.children.map { $0.id })
            let resultingFoldedIds = foldedIds.union(virtualArcContext.foldedIds)
            var resultingWeightDictionary = weightDictionary
            virtualArcContext.weightDictionary.forEach { (weightLessVirtualArc, weight) in
                guard !resultingFoldedIds.contains(weightLessVirtualArc.destinationIdentifier) else {
                    return
                }
                let newNeightLessVirtualArc = VirtualArcContext.WeightLessVirtualArc(
                    sourceIdentifier: node.id,
                    destinationIdentifier: weightLessVirtualArc.destinationIdentifier
                )
                resultingWeightDictionary[newNeightLessVirtualArc] = resultingWeightDictionary[newNeightLessVirtualArc, default: 0] + weight
            }
            let childrenDestinationMapping = virtualArcContext.destinationMapping.map {($0.key, node.id)}
            let destinationMapping = Dictionary(uniqueKeysWithValues: node.children.map {($0.id, node.id)})
            let resultingDestinationMapping = destinationMapping.merging(
                childrenDestinationMapping,
                uniquingKeysWith: { $1 }
            )
            let resultingVirtualArcContext = VirtualArcContext(
                weightDictionary: resultingWeightDictionary,
                destinationMapping: resultingDestinationMapping,
                foldedIds: resultingFoldedIds,
                hiddenIds: virtualArcContext.hiddenIds
            )
            virtualArcContextCache[transformationContext] = resultingVirtualArcContext
            return resultingVirtualArcContext
        }
    }

    private static func createVirtualArcContext(from children: [Node], with transformations: Set<FirstOrderVirtualTransformation>, isParentFolded: Bool = false) -> VirtualArcContext {
        var weightDictionary: [VirtualArcContext.WeightLessVirtualArc: Int] = [:]
        var destinationMapping: [UUID: UUID] = [:]
        var foldedIds: Set<UUID> = []
        var hiddenIds: Set<UUID> = []
        children.forEach { child in
            let virtualArcContext = createVirtualArcContext(
                from: child,
                with: transformations,
                isParentFolded: isParentFolded
            )
            weightDictionary = weightDictionary.merging(virtualArcContext.weightDictionary, uniquingKeysWith: { $0 + $1 })
            destinationMapping.merge(virtualArcContext.destinationMapping) { $1 }
            foldedIds = foldedIds.union(virtualArcContext.foldedIds)
            hiddenIds = hiddenIds.union(virtualArcContext.hiddenIds)
        }
        return VirtualArcContext(
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

extension VirtualArc: CustomStringConvertible {

    // MARK: - Internal -

    public var description: String {
        """

sourceIdentifier:      \(sourceIdentifier.uuidString)
destinationIdentifier: \(destinationIdentifier.uuidString)
weight:                \(weight)

"""
    }

}
