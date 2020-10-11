// Copyright © 2020 Stephan Lerner. All rights reserved.

import AppKit

public struct VirtualNode: Identifiable, Equatable {

    // MARK: - Public -

    public struct Settings {
        public let colorDictionary: [String: NSColor]
        public let defaultColor: NSColor
        public let baseRadius: CGFloat
        public let areaMultiplier: CGFloat
        
        public init(colorDictionary: [String: NSColor], defaultColor: NSColor, baseRadius: CGFloat, areaMultiplier: CGFloat) {
            self.colorDictionary = colorDictionary
            self.defaultColor = defaultColor
            self.baseRadius = baseRadius
            self.areaMultiplier = areaMultiplier
        }
    }

    public let id: UUID
    public let scope: String
    public let name: String?
    public let children: [VirtualNode]
    public let color: NSColor
    public let radius: CGFloat
    
    public init(id: UUID, scope: String, name: String?, children: [VirtualNode], color: NSColor, radius: CGFloat) {
        self.id = id
        self.scope = scope
        self.name = name
        self.children = children
        self.color = color
        self.radius = radius
    }


    public static func createVirtualNodes(from node: Node, with transformations: Set<VirtualTransformation>, and settings: VirtualNode.Settings) -> [VirtualNode] {

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
