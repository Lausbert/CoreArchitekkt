// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

extension Node: Equatable {

    // MARK: - Public -

    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
