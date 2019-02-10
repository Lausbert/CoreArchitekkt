//
//  Arc.swift
//  CoreArchitekkt
//
//  Created by Stephinsky on 29.12.18.
//  Copyright © 2018 StephanLerner. All rights reserved.
//

import Foundation

public class Arc: Codable {
    
    public enum ErrorEnum: LocalizedError, Equatable {
        case unexpectedUnidentifiableArcDestination
        
        public var errorDescription: String? {
            switch self {
            case .unexpectedUnidentifiableArcDestination:
                return "Unexpected unidentifiable arc destination."
            }
        }
    }
    
    let destination: Node
    
    public init(destination: Node) {
        assert(destination.identifier != nil, "Unexpected unidentifiable arc destination.")
        self.destination = destination
    }
    
    // Mark: Codable
    
    enum CodingKeys: CodingKey {
        case destination
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.destination = try container.decode(Node.self, forKey: .destination)
    }
    
    public func encode(to encoder: Encoder) throws {
        // reinitialize destination without arcs to avoid infinite loops during encoding due to circular dependencies between reference types
        guard let identifier = destination.identifier else { throw ErrorEnum.unexpectedUnidentifiableArcDestination }
        let scope = destination.scope
        let node = Node(identifier: identifier, scope: scope)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(node, forKey: .destination)
    }
    
}
