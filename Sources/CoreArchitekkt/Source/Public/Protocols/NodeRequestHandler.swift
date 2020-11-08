//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public protocol NodeRequestHandler {

    var consistentUrlRequirements: [ConsistentUrlRequirement]? { get }

    var handableFileExtensions: [String] { get }

    func handle(nodeRequest: NodeRequest, statusUpdateHandler: ((NodeRequest.StatusUpdate) -> Void)?, completionHandler: @escaping (NodeRequest.Result) -> Void)

}
