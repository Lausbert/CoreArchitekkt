//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class SettingsItem: ObservableObject, Codable, Hashable {

    // MARK: - Public -

    public let name: String
    @Published public var value: SettingsValue

    public init(name: String, value: SettingsValue, initialValue: SettingsValue? = nil) {
        self.name = name
        self.value = value
        self.initialValue = initialValue
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decode(SettingsValue.self, forKey: .value)
        self.initialValue = try container.decode(SettingsValue?.self, forKey: .initialValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        try container.encode(initialValue, forKey: .initialValue)
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(value)
    }
    // MARK: - Internal -
    
    enum CodingKeys: CodingKey {
        case name, value, initialValue
    }
    
    let initialValue: SettingsValue?

}

extension SettingsItem: Equatable {
    public static func == (lhs: SettingsItem, rhs: SettingsItem) -> Bool {
        lhs.name == rhs.name && lhs.value == rhs.value && lhs.initialValue == rhs.initialValue
    }
}
