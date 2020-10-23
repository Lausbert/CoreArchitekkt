// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

extension URL {
    
    init(staticString: StaticString) {
        guard let url = URL(string: String(describing: staticString)) else {
            fatalError()
        }
        self = url
    }
    
}
