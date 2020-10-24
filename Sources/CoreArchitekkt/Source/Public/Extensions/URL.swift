// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public extension URL {
    
    init(staticString: StaticString) {
        guard let url = URL(string: String(describing: staticString)) else {
            fatalError()
        }
        self = url
    }
    
}
