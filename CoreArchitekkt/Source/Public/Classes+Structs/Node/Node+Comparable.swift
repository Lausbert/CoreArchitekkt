//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

extension Node: Comparable {

    // MARK: - Public -

    public static func < (lhs: Node, rhs: Node) -> Bool {
        if let firstIdentifierLhs = getFirstIdentifier(node: lhs), let firstIdentifierRhs = getFirstIdentifier(node: rhs) {
            return firstIdentifierLhs < firstIdentifierRhs
        }
        return false
    }

    // MARK: - Private -

    private static func getFirstIdentifier(node: Node) -> String? {
        guard node.identifier == nil else { return node.identifier }
        for child in node.children {
            if let identifier = child.identifier {
                return identifier
            }
        }
        return nil
    }

}
