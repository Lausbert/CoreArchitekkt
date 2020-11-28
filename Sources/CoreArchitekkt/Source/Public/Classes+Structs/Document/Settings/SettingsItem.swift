//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct SettingsItem: Codable, Hashable {
    
    // MARK: - Public -

    public let name: String
    public var value: SettingsValue

    public init(name: String, value: SettingsValue) {
        self.name = name
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decode(SettingsValue.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(value)
    }
    // MARK: - Internal -
    
    enum CodingKeys: CodingKey {
        case name, value
    }
    
}

extension SettingsItem: Equatable {
    public static func == (lhs: SettingsItem, rhs: SettingsItem) -> Bool {
        lhs.name == rhs.name && lhs.value == rhs.value
    }
}
