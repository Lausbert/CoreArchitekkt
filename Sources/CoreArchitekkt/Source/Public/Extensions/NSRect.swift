//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public extension NSRect {

    var center: NSPoint {
        return NSPoint(x: midX, y: midY)
    }

}
