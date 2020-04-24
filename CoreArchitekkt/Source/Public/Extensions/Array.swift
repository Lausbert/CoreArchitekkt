// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public extension Array {

    subscript(safe index: Int) -> Element? {
        index >= startIndex && index < endIndex ? self[index] : nil
    }

}
