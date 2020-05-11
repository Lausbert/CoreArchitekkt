//  Copyright © 2019 Stephan Lerner. All rights reserved.

import AppKit

public extension NSWindowController {

    func child<T: NSViewController>() -> T? {
        return contentViewController as? T
    }

}
