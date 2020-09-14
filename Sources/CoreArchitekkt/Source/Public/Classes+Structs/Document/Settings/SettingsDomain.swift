//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class SettingsDomain: Codable, Hashable, Identifiable {
    
    // MARK: - Public -

    public let name: String
    public let settingsGroups: [SettingsGroup]
    public var settingsItems: [SettingsItem] {
        settingsGroups.flatMap { $0.settingsItems }
    }
    
    public init(name: String, settingsGroups: [SettingsGroup]) {
        self.name = name
        self.settingsGroups = settingsGroups
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(settingsGroups)
    }
    
    public static func == (lhs: SettingsDomain, rhs: SettingsDomain) -> Bool {
        lhs.name == rhs.name && lhs.settingsGroups == rhs.settingsGroups
    }

}
