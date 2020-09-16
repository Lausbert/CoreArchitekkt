//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct ConsistentUrlRequirement: Equatable, Hashable {

    // MARK: - Public -

    public let key: String
    public let hint: String
    public let fileName: String
    public let fileType: String

    public init(key: String, hint: String, fileName: String, fileType: String) {
        self.key = key
        self.hint = hint
        self.fileName = fileName
        self.fileType = fileType
    }

}
