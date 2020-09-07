// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

extension KeyedEncodingContainer {

    mutating func encodeValues<V1: Encodable, V2: Encodable>(
        _ v1: V1,
        _ v2: V2,
        for key: Key) throws {

        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
    }

    mutating func encodeValues<V1: Encodable, V2: Encodable, V3: Encodable>(
        _ v1: V1,
        _ v2: V2,
        _ v3: V3,
        for key: Key) throws {

        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
        try container.encode(v3)
    }

}
