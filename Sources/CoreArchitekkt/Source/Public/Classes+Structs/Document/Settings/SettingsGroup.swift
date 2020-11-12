//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation
import Combine

public struct SettingsGroup: Codable, Hashable {
    
    // MARK: - Public -

    public let name: String
    public var settingsItems: [SettingsItem]
    public let preferredNewValue: SettingsValue?

    public mutating func reset() {
        let oldSettingsItems = settingsItems
        settingsItems = oldSettingsItems.compactMap { oldSettingsItem in
            if let initialValue = oldSettingsItem.initialValue {
                return SettingsItem(name: oldSettingsItem.name, value: initialValue, initialValue: initialValue)
            } else {
                return nil
            }
        }
    }

    public mutating func toggle(settingsItem: SettingsItem) {
        if settingsItems.contains(settingsItem) {
            remove(settingsItem: settingsItem)
        } else {
            settingsItems.append(settingsItem)
        }
    }
    
    public mutating func add(settingsItem: SettingsItem) {
        settingsItems.append(settingsItem)
    }

    public mutating func remove(settingsItem: SettingsItem) {
        guard let index = settingsItems.firstIndex(of: settingsItem) else {
            return
        }
        settingsItems.remove(at: index)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.settingsItems = try container.decode([SettingsItem].self, forKey: .settingsItems)
        self.preferredNewValue = try? container.decode(SettingsValue.self, forKey: .preferredNewValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(settingsItems, forKey: .settingsItems)
        try? container.encode(preferredNewValue, forKey: .preferredNewValue)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(settingsItems)
    }
    
    public static func == (lhs: SettingsGroup, rhs: SettingsGroup) -> Bool {
        return lhs.name == rhs.name && lhs.settingsItems == rhs.settingsItems
    }
    
    // MARK: - Internal -
    
    init(name: String, settingsItems: [SettingsItem], preferredNewValue: SettingsValue? = nil) {
        self.name = name
        self.settingsItems = settingsItems
        self.preferredNewValue = preferredNewValue
    }
    
    // MARK: - Private -
    
    enum CodingKeys: CodingKey {
        case name, settingsItems, preferredNewValue
    }
    
}
