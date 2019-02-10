//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public extension String {
    
    func losslessComponents(beginningWith: String) -> [String] {
        return self.components(separatedBy: beginningWith).compactMap({ (string) -> String? in
            return string.isEmpty ? nil : beginningWith + string
        })
    }
    
}
