//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct Settings: Codable {

    // MARK: - Public -
    
    public init() {
        // Force & Geometry
        let v0 = SettingsValue.range(value: 0.75, minValue: 0.5, maxValue: 1)
        let v1 = SettingsValue.range(value: 50, minValue: 0, maxValue: 100)
        let v2 = SettingsValue.range(value: -1.3, minValue: -2.3, maxValue: -0.3)
        let v3 = SettingsValue.range(value: 1.1, minValue: 0.2, maxValue: 2.0)
        let v4 = SettingsValue.range(value: 64, minValue: 0.1, maxValue: 127.9)
        let v5 = SettingsValue.range(value: 1.5, minValue: 0.1, maxValue: 2.9)
        firstDomains = [
            SettingsDomain(
                name: "Force Settings",
                settingsGroups: [
                    SettingsGroup(
                        name: "",
                        settingsItems: [
                            SettingsItem(name: "Friction", value: v0, initialValue: v0),
                            SettingsItem(name: "Radial Force on Children", value: v1, initialValue: v1),
                            SettingsItem(name: "Negative Radial Force on Siblings", value: v2, initialValue: v2),
                            SettingsItem(name: "Spring Force on Connected Nodes", value: v3, initialValue: v3)
                        ]
                    )
                ]
            ),
            SettingsDomain(
                name: "Geometry Settings",
                settingsGroups: [
                    SettingsGroup(
                        name: "",
                        settingsItems: [
                            SettingsItem(name: "Node Radius", value: v4, initialValue: v4),
                            SettingsItem(name: "Arc Width", value: v5, initialValue: v5)
                        ]
                    )
                ]
            )
        ]
        
        // Visibility
        secondDomains = [
            SettingsDomain(
                name: "Visibility Settings",
                settingsGroups: [
                    SettingsGroup(name: "Unfolded Nodes", settingsItems: [], preferredNewValue: .deletable(virtualTransformation: .unfoldNodes(regex: ""))),
                    SettingsGroup(name: "Hidden Nodes", settingsItems: [], preferredNewValue: .deletable(virtualTransformation: .hideNodes(regex: ""))),
                    SettingsGroup(name: "Flattened Nodes", settingsItems: [], preferredNewValue: .deletable(virtualTransformation: .flattenNodes(regex: ""))),
                    SettingsGroup(name: "Unfolded Scopes", settingsItems: [], preferredNewValue: .deletable(virtualTransformation: .unfoldScopes(regex: ""))),
                    SettingsGroup(name: "Hidden Scopes", settingsItems: [], preferredNewValue: .deletable(virtualTransformation: .hideScopes(regex: ""))),
                    SettingsGroup(name: "Flattened Scopes", settingsItems: [], preferredNewValue: .deletable(virtualTransformation: .flattenScopes(regex: "")))
                ]
            )
        ]
    }
    
    // MARK: Domains
    
    public var firstDomains: [SettingsDomain]
    public var secondDomains: [SettingsDomain]

    // MARK: Force
    
    public var forceSettingsDomain: SettingsDomain {
        firstDomains[0]
    }
    public var decayPower: Double {
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[0].value {
            return value
        } else {
            assertionFailure()
            return 0.75
        }
    }
    public var radialGravitationForceOnChildrenMultiplier: Double {
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[1].value {
            return value
        } else {
            assertionFailure()
            return 1
        }
    }
    public var negativeRadialGravitationalForceOnSiblingsPower: Double {
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[2].value {
            return value
        } else {
            assertionFailure()
            return -1.3
        }
    }
    public var springForceBetweenConnectedNodesPower: Double {
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[3].value {
            return value
        } else {
            assertionFailure()
            return 1.5
        }
    }
    
    // MARK: Geometry
    
    public var geometrySettingsDomain: SettingsDomain  {
        firstDomains[1]
    }
    public var visualRadiusMultiplier: Double {
        if case let .range(value, _, _) = geometrySettingsGroup.settingsItems[0].value {
            return value
        } else {
            assertionFailure()
            return 2
        }
    }
    public var arcWidthMultiplier: Double {
        if case let .range(value, _, _) = geometrySettingsGroup.settingsItems[1].value {
            return value
        } else {
            assertionFailure()
            return 5
        }
    }

    // MARK: Visibility

    public var visibilitySettingsDomain: SettingsDomain {
        secondDomains[0]
    }
    public var virtualTransformations: Set<VirtualTransformation> {
        Set(
            settingsItems.compactMap { settingsItem in
                switch settingsItem.value {
                case let .deletable(virtualTransformation):
                    switch virtualTransformation {
                    case let .unfoldNodes(regex), let .hideNodes(regex), let .flattenNodes(regex), let .unfoldScopes(regex), let .hideScopes(regex), let .flattenScopes(regex):
                        return regex.isEmpty ? nil : virtualTransformation
                    default:
                        return virtualTransformation
                    }
                default:
                    return nil
                }
            }
        )
    }
    
    public mutating func toggle(settingsItem: SettingsItem) {
        switch settingsItem.value {
        case let .deletable(virtualTransformation):
            switch virtualTransformation {
            case .unfoldNode:
                secondDomains[0].settingsGroups[0].toggle(settingsItem: settingsItem)
            case .hideNode:
                secondDomains[0].settingsGroups[1].toggle(settingsItem: settingsItem)
            case .flattenNode:
                secondDomains[0].settingsGroups[2].toggle(settingsItem: settingsItem)
            case .unfoldScope:
                secondDomains[0].settingsGroups[3].toggle(settingsItem: settingsItem)
            case .hideScope:
                secondDomains[0].settingsGroups[4].toggle(settingsItem: settingsItem)
            case .flattenScope:
                secondDomains[0].settingsGroups[5].toggle(settingsItem: settingsItem)
            default:
                assertionFailure()
            }
        default:
            assertionFailure()
        }
    }

    // MARK: - Private -
    
    // MARK: Force
    
    private var forceSettingsGroup: SettingsGroup {
        forceSettingsDomain.settingsGroups[0]
    }
    
    // MARK: Geometry
    
    private var geometrySettingsGroup: SettingsGroup {
        geometrySettingsDomain.settingsGroups[0]
    }
    
    // MARK: Other
    
    private var settingsItems: [SettingsItem] {
        (firstDomains + secondDomains)
            .compactMap { $0 }
            .flatMap { $0.settingsGroups }
            .flatMap { $0.settingsItems }
    }
    
}
