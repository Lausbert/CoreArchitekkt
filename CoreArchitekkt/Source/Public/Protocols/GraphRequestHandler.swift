//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public protocol GraphRequestHandler {

    var handableFileExtensions: [String] { get }

    func handle(graphRequest: GraphRequest, statusUpdateHandler: ((GraphRequest.StatusUpdate) -> Void)?, completionHandler: @escaping (GraphRequest.Result) -> Void)

}
