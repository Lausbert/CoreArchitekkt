//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct AccessRequirement: Hashable {

    // MARK: - Public -

    let key: String
    let description: String
    let fileName: String?
    let fileType: String?

    public init(key: String, description: String, fileName: String?, fileType: String?) {
        self.key = key
        self.description = description
        self.fileName = fileName
        self.fileType = fileType
    }

}
