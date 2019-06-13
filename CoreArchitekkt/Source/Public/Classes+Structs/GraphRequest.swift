//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct GraphRequest {

    // MARK: - Public -

    public let url: URL
    public let options: [Parameter: Option]

    public init(url: URL, options: [Parameter: Option]) {
        self.url = url
        self.options = options
    }

    public typealias Parameter = String

    public typealias Option = String

    public typealias Procedure = String

    public typealias AdditionalInformation = String

    public enum StatusUpdate {
        case willStartProcedure(GraphRequest, Procedure)
        case didFinishProcedure(GraphRequest, Procedure, AdditionalInformation?)
    }

    /// The result of handling a graph request.
    ///
    /// - success: The result, when no additional parameter was needed and no error occured. The graphRequest contains also automatically updated options. The node is the root node and containts the graph as its children. Only nodes that are no children of any other node than the root node are directly contained in a graph. Every other note is contained in exactly one children array of another node. Additionally any node could be contained in any number of arc arrays of any other node, if this node is neither an ancestor nor a descendant.
    /// - decisionNeeded: todo
    /// - failure: todo
    public enum Result {
        case success(GraphRequest, Node)
        case decisionNeeded(GraphRequest, [Parameter:[Option]])
        case failure(GraphRequest, Error)
    }

}
