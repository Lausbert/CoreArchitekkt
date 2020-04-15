//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

extension Node: Comparable {

    // MARK: - Public -

    public static func < (lhs: Node, rhs: Node) -> Bool {
        if let firstNameLhs = getFirstName(node: lhs), let firstNameRhs = getFirstName(node: rhs) {
            return firstNameLhs < firstNameRhs
        }
        return false
    }

    // MARK: - Private -

    private static func getFirstName(node: Node) -> String? {
        guard node.name == nil else { return node.name }
        for child in node.children {
            if let name = child.name {
                return name
            }
        }
        return nil
    }

}
