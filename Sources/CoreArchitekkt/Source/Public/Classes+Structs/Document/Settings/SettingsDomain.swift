//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation
import Combine

public class SettingsDomain: ObservableObject, Codable, Hashable, Identifiable {
    
    // MARK: - Public -

    public let name: String
    @Published public var settingsGroups: [SettingsGroup] {
        didSet {
            updateCancellables()
        }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.settingsGroups = try container.decode([SettingsGroup].self, forKey: .settingsGroups)
        updateCancellables()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
        self.name = name
        self.settingsGroups = settingsGroups
        updateCancellables()
    }
    
    // MARK: - Private -
    
    enum CodingKeys: CodingKey {
        case name, settingsGroups
    }
    
    private var cancellables: [AnyCancellable] = []
    
    private func updateCancellables() {
        cancellables = settingsGroups.map({ settingsGroup -> AnyCancellable in
            settingsGroup.objectDidChange.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        })
    }
}
