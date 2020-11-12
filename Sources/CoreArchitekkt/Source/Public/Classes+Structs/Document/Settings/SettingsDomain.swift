//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation
import Combine

public struct SettingsDomain: Codable, Hashable, Identifiable {
    
    // MARK: - Public -

    public let id: UUID
    public let name: String
    public var settingsGroups: [SettingsGroup]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.settingsGroups = try container.decode([SettingsGroup].self, forKey: .settingsGroups)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(settingsGroups, forKey: .settingsGroups)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(settingsGroups)
    }
    
    public static func == (lhs: SettingsDomain, rhs: SettingsDomain) -> Bool {
        lhs.name == rhs.name && lhs.settingsGroups == rhs.settingsGroups
    }
    
    // MARK: - Internal -
    
    init(name: String, settingsGroups: [SettingsGroup]) {
        self.id = UUID()
        self.name = name
        self.settingsGroups = settingsGroups
    }
    
    // MARK: - Private -
    
    enum CodingKeys: CodingKey {
        case id, name, settingsGroups
    }
    
}
