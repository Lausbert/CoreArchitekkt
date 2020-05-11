//  Copyright © 2019 Stephan Lerner. All rights reserved.

import AppKit

public extension NSViewController {

    func child<T>() -> T? {
        return children.filter { $0 is T }.first as? T
    }

}
