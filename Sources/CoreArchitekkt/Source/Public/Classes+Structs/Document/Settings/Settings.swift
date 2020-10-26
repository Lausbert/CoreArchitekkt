//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public class Settings: Codable {

    // MARK: - Public -
    
    public init() {
        // Force
        let v1 = SettingsValue.range(value: 0.75, minValue: 0.5, maxValue: 1)
        let v2 = SettingsValue.range(value: 1, minValue: 0, maxValue: 2)
        let v3 = SettingsValue.range(value: -1.3, minValue: -2.3, maxValue: -0.3)
        let v4 = SettingsValue.range(value: 1.5, minValue: 0.2, maxValue: 2.8)
        decayPowerSettingsItem = SettingsItem(name: "Friction", value: v1, initialValue: v1)
        radialGravitationForceOnChildrenMultiplierSettingsItem = SettingsItem(name: "Radial Force on Children", value: v2, initialValue: v2)
        negativeRadialGravitationalForceOnSiblingsPowerSettingsItem = SettingsItem(name: "Negative Radial Force on Siblings", value: v3, initialValue: v3)
        springForceBetweenConnectedNodesPowerSettingsItem = SettingsItem(name: "Spring Force on Connected Nodes", value: v4, initialValue: v4)
        // Area
        
        // Visibility
        unfoldedNodesSettingsGroup = SettingsGroup(name: "Unfolded Nodes", settingsItems: [])
        hiddenNodesSettingsGroup = SettingsGroup(name: "Hidden Nodes", settingsItems: [])
        flattendedNodesSettingsGroup = SettingsGroup(name: "Flattened Nodes", settingsItems: [])
        unfoldedScopesSettingsGroup = SettingsGroup(name: "Unfolded Scopes", settingsItems: [])
        hiddenScopesSettingsGroup = SettingsGroup(name: "Hidden Scopes", settingsItems: [])
        flattendedScopesSettingsGroup = SettingsGroup(name: "Flattened Scopes", settingsItems: [])
    }
    
    // MARK: Domains
    
    public lazy var domains: [SettingsDomain] = {
        firstDomains + secondDomains
    }()
    
    public lazy var firstDomains: [SettingsDomain] = {
        [
            forceSettingsDomain,
            areaSettingsDomain
        ]
    }()
    
    public lazy var secondDomains: [SettingsDomain] = {
        [
            visibilitySettingsDomain
        ]
    }()

    // MARK: Force
    
    public lazy var forceSettingsDomain: SettingsDomain = {
        SettingsDomain(
            name: "Force Settings",
            settingsGroups: [
                forceSettingsGroup
            ]
        )
    }()

    public var decayPower: Double {
        if case let .range(value, _, _) = decayPowerSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return 0.75
        }
    }
    public var radialGravitationForceOnChildrenMultiplier: Double {
        if case let .range(value, _, _) = radialGravitationForceOnChildrenMultiplierSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return 1
        }
    }
    public var negativeRadialGravitationalForceOnSiblingsPower: Double {
        if case let .range(value, _, _) = negativeRadialGravitationalForceOnSiblingsPowerSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return -1.3
        }
    }
    public var springForceBetweenConnectedNodesPower: Double {
        if case let .range(value, _, _) = springForceBetweenConnectedNodesPowerSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return 1.5
        }
    }
    
    // MARK: Area
    
    public lazy var areaSettingsDomain: SettingsDomain = {
        SettingsDomain(
            name: "Area Settings",
            settingsGroups: [
                areaSettingsGroup
            ]
        )
    }()

    

    // MARK: Visibility

    public lazy var visibilitySettingsDomain: SettingsDomain = {
        SettingsDomain(
            name: "Visibility Settings",
            settingsGroups: [
                unfoldedNodesSettingsGroup,
                hiddenNodesSettingsGroup,
                flattendedNodesSettingsGroup,
                unfoldedScopesSettingsGroup,
                hiddenScopesSettingsGroup,
                flattendedScopesSettingsGroup
            ]
        )
    }()
    
    // MARK: Other
    
    public var virtualTransformations: Set<VirtualTransformation> {
        Set(
            settingsItems.compactMap { settingsItem in
                switch settingsItem.value {
                case let .deletable(transformation):
                    return transformation
                default:
                    return nil
                }
            }
        )
    }
    
    public func toggle(settingsItem: SettingsItem) {
        switch settingsItem.value {
        case let .deletable(virtualTransformation):
            switch virtualTransformation {
            case .unfoldNode:
                unfoldedNodesSettingsGroup.toggle(settingsItem: settingsItem)
            case .hideNode:
                hiddenNodesSettingsGroup.toggle(settingsItem: settingsItem)
            case .flattenNode:
                flattendedNodesSettingsGroup.toggle(settingsItem: settingsItem)
            case .unfoldScope:
                unfoldedScopesSettingsGroup.toggle(settingsItem: settingsItem)
            case .hideScope:
                hiddenScopesSettingsGroup.toggle(settingsItem: settingsItem)
            case .flattenScope:
                flattendedScopesSettingsGroup.toggle(settingsItem: settingsItem)
            }
        default:
            assertionFailure()
        }
    }

    // MARK: - Private -
    
    // MARK: Force
    
    private lazy var forceSettingsGroup = SettingsGroup(
        name: "",
        settingsItems: [
            decayPowerSettingsItem,
            radialGravitationForceOnChildrenMultiplierSettingsItem,
            negativeRadialGravitationalForceOnSiblingsPowerSettingsItem,
            springForceBetweenConnectedNodesPowerSettingsItem
        ]
    )
    
    private let decayPowerSettingsItem: SettingsItem
    private let radialGravitationForceOnChildrenMultiplierSettingsItem: SettingsItem
    private let negativeRadialGravitationalForceOnSiblingsPowerSettingsItem: SettingsItem
    private let springForceBetweenConnectedNodesPowerSettingsItem: SettingsItem
    
    // MARK: Area
    
    private lazy var areaSettingsGroup = SettingsGroup(
        name: "",
        settingsItems: [
            
        ]
    )
        
    // MARK: Visibility
    
    private let unfoldedNodesSettingsGroup: SettingsGroup
    private let hiddenNodesSettingsGroup: SettingsGroup
    private let flattendedNodesSettingsGroup: SettingsGroup
    private let unfoldedScopesSettingsGroup: SettingsGroup
    private let hiddenScopesSettingsGroup: SettingsGroup
    private let flattendedScopesSettingsGroup: SettingsGroup
    
    // MARK: Other
    
    private var settingsItems: [SettingsItem] {
        domains
            .compactMap { $0 }
            .flatMap { $0.settingsGroups }
            .flatMap { $0.settingsItems }
    }
}
