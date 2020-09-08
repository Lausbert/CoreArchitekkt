//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class SettingsGroup: ObservableObject, Codable {

    // MARK: - Public -

    public let name: String
    @Published public private(set) var settingsItems: [SettingsItem]

    public func reset() {
        for settingsItem in settingsItems.reversed() {
            if let initialValue = settingsItem.initialValue {
                settingsItem.value = initialValue
            } else {
                settingsItems.remove(element: settingsItem)
            }
        }
    }

    public func toggle(settingsItem: SettingsItem) {
        if settingsItems.contains(settingsItem) {
            remove(settingsItem: settingsItem)
        } else {
            settingsItems.append(settingsItem)
        }
    }

    public func remove(settingsItem: SettingsItem) {
        guard let index = settingsItems.firstIndex(of: settingsItem) else {
            assertionFailure()
            return
        }
        settingsItems.remove(at: index)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.settingsItems = try container.decode([SettingsItem].self, forKey: .settingsItems)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        let filteredSettingsItems = settingsItems.filter {
            switch $0.value {
            case .range:
                return true
            default:
                return false
            }
        }
        try container.encode(filteredSettingsItems, forKey: .settingsItems)
    }
    
    // MARK: - Internal -
    
    enum CodingKeys: CodingKey {
        case name, settingsItems
    }
    
    init(name: String, settingsItems: [SettingsItem]) {
        self.name = name
        self.settingsItems = settingsItems
    }

}
