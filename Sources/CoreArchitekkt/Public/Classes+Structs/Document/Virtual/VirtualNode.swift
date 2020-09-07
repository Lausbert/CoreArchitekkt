// Copyright © 2020 Stephan Lerner. All rights reserved.

import AppKit
import CoreArchitekkt

struct VirtualNode: Identifiable, Equatable {

    // MARK: - Internal -

    struct Settings {
        let colorDictionary: [String: NSColor]
        let defaultColor: NSColor
        let baseRadius: CGFloat
        let areaMultiplier: CGFloat
    }

    let id: UUID
    let scope: String
    let name: String?
    let children: [VirtualNode]
    let color: NSColor
    let radius: CGFloat

    static func createVirtualNodes(from node: Node, with transformations: Set<VirtualTransformation>, and settings: VirtualNode.Settings) -> [VirtualNode] {

        if transformations.contains(.hideNode(id: node.id)) || transformations.contains(.hideScope(scope: node.scope)) {
            return []
        } else if transformations.contains(.flattenNode(id: node.id)) || transformations.contains(.flattenScope(scope: node.scope)) {
            return node.children.flatMap { createVirtualNodes(from: $0, with: transformations, and: settings) }
        } else if transformations.contains(.unfoldNode(id: node.id)) || transformations.contains(.unfoldScope(scope: node.scope)) {
            let childrenVirtualNodes = node.children.flatMap { createVirtualNodes(from: $0, with: transformations, and: settings) }
            let r = radius(for: childrenVirtualNodes, and: settings)
            return[
                VirtualNode(
                    id: node.id,
                    scope: node.scope,
                    name: node.name,
                    children: childrenVirtualNodes,
                    color: settings.colorDictionary[node.scope, default: settings.defaultColor],
                    radius: r
                )
            ]
        }

        return [
            VirtualNode(
                id: node.id,
                scope: node.scope,
                name: node.name,
                children: [],
                color: settings.colorDictionary[node.scope, default: settings.defaultColor],
                radius: settings.baseRadius
            )
        ]
    }

    // MARK: - Private -

    private static func radius(for children: [VirtualNode], and settings: VirtualNode.Settings) -> CGFloat {
        max(settings.baseRadius, (sqrt(settings.areaMultiplier*children.map {$0.radius^^2} .reduce(0, +))))
    }

}

extension VirtualNode: CustomStringConvertible {

    // MARK: - Internal -

    var description: String {
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
        result += "\(newLine)color: \(color)"
        result += "\(newLine)radius: \(radius)"
        if !children.isEmpty {
            result += "\(newLine)children: ["
            result += "\(children.map({ $0.description(forNestingLevel: level + 1) }).joined(separator: ","))"
            result += "\(newLine)]"
        }
        return result
    }

}
