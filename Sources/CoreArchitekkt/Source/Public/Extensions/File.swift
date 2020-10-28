// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public extension Dictionary {
    
    subscript(key: Optional<Key>) -> Value? {
        if let key = key {
            return self[key]
        } else {
            return nil
        }
    }
    
}
