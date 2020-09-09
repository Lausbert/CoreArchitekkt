// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

extension KeyedDecodingContainer {

    func decodeValues<V1: Decodable, V2: Decodable>(
        for key: Key) throws -> (V1, V2) {

        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self)
        )
    }

    func decodeValues<V1: Decodable, V2: Decodable, V3: Decodable>(
        for key: Key) throws -> (V1, V2, V3) {

        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self),
            try container.decode(V3.self)
        )
    }

}
