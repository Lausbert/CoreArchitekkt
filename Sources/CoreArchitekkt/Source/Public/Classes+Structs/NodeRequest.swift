//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct NodeRequest: Codable {

    // MARK: - Public -

    public let url: URL
    public let options: [Parameter: Option]
    public let consistentlyRequiredUrls: [ConsistentUrlRequirement: URL]
    
    public var description: String {
        let joinedOptions = options.values.joined(separator: " | ")
        if joinedOptions.isEmpty  {
            return url.deletingPathExtension().lastPathComponent
        } else {
            return url.deletingPathExtension().lastPathComponent + " : " + joinedOptions
        }
    }

    public init(url: URL, options: [Parameter: Option], consistentlyRequiredUrls: [ConsistentUrlRequirement: URL] = [:]) {
        self.url = url
        self.options = options
        self.consistentlyRequiredUrls = consistentlyRequiredUrls
    }
    
    public typealias Warning = String

    public typealias Parameter = String

    public typealias Option = String

    public typealias Procedure = String

    public typealias AdditionalInformation = String
    
    public enum StatusUpdate {
        case willStartProcedure(NodeRequest, Procedure)
        case didFinishProcedure(NodeRequest, Procedure, AdditionalInformation?)
    }

    /// The result of handling a node request.
    ///
    /// - success: The result, when no additional parameter was needed and no error occured. The nodeRequest contains also automatically updated options. The node is the root node and containts the node as its children. Only nodes that are no children of any other node than the root node are directly contained in a node. Every other note is contained in exactly one children array of another node. Additionally any node could be contained in any number of arc arrays of any other node, if this node is neither an ancestor nor a descendant.
    /// - decisionNeeded: todo
    /// - failure: todo
    public enum Result {
        case success(NodeRequest, Node, [Warning])
        case decisionNeeded(NodeRequest, (Parameter, [Option]))
        case failure(NodeRequest, Error)
    }

}
