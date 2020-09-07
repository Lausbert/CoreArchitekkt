//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation
import Combine

public class Settings: Codable {

    // MARK: - Public -

    public var settingsGroups: [SettingsGroup] {
        forceSettingsGroups + visibilitySettingsGroups
    }
    public var settingsItems: [SettingsItem] {
        return settingsGroups.flatMap { $0.settingsItems }
    }

    // MARK: Force

    public let decayPowerSettingsItem: SettingsItem
    public let radialGravitationForceOnChildrenMultiplierSettingsItem: SettingsItem
    public let negativeRadialGravitationalForceOnSiblingsPowerSettingsItem: SettingsItem
    public let springForceBetweenConnectedNodesPowerSettingsItem: SettingsItem
    public let areaBasedOnTotalChildrensAreaMultiplierSettingsItem: SettingsItem

    public var decayPower: Double {
        if case let .range(value, _, _) = decayPowerSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return 0.5
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
            return -1.1
        }
    }
    public var springForceBetweenConnectedNodesPower: Double {
        if case let .range(value, _, _) = springForceBetweenConnectedNodesPowerSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return 2.3
        }
    }
    public var areaBasedOnTotalChildrensAreaMultiplier: Double {
        if case let .range(value, _, _) = areaBasedOnTotalChildrensAreaMultiplierSettingsItem.value {
            return value
        } else {
            assertionFailure()
            return 4
        }
    }

    public lazy var forceSettingsGroups: [SettingsGroup] = {
        return [
            SettingsGroup(name: "Friction", settingsItems: [
                decayPowerSettingsItem
                ]),
            SettingsGroup(name: "Radial Gravitational Force On Children", settingsItems: [
                radialGravitationForceOnChildrenMultiplierSettingsItem
                ]),
            SettingsGroup(name: "Negative Radial Gravitational Force On Siblings", settingsItems: [
                negativeRadialGravitationalForceOnSiblingsPowerSettingsItem
                ]),
            SettingsGroup(name: "Spring Force Between Connected Nodes", settingsItems: [
                springForceBetweenConnectedNodesPowerSettingsItem
                ]),
            SettingsGroup(name: "Area Based On Total Childrens Area", settingsItems: [
                areaBasedOnTotalChildrensAreaMultiplierSettingsItem
                ])
        ]
    }()

    // MARK: Visibility

    public let unfoldedNodesSettingsGroup: SettingsGroup
    public let hiddenNodesSettingsGroup: SettingsGroup
    public let flattendedNodesSettingsGroup: SettingsGroup
    public let unfoldedScopesSettingsGroup: SettingsGroup
    public let hiddenScopesSettingsGroup: SettingsGroup
    public let flattendedScopesSettingsGroup: SettingsGroup

    public lazy var visibilitySettingsGroups: [SettingsGroup] = {
        return [
            unfoldedNodesSettingsGroup,
            hiddenNodesSettingsGroup,
            flattendedNodesSettingsGroup,
            unfoldedScopesSettingsGroup,
            hiddenScopesSettingsGroup,
            flattendedScopesSettingsGroup
        ]
    }()

    // MARK: - Internal -

    init() {
        // Force
        let v1 = SettingsValue.range(value: 0.5, minValue: 0, maxValue: 1)
        let v2 = SettingsValue.range(value: 1, minValue: 0, maxValue: 2)
        let v3 = SettingsValue.range(value: -1.1, minValue: -2.1, maxValue: -0.1)
        let v4 = SettingsValue.range(value: 2.3, minValue: 1, maxValue: 3.6)
        let v5 = SettingsValue.range(value: 4, minValue: 2, maxValue: 6)
        decayPowerSettingsItem = SettingsItem(name: "Power", value: v1, initialValue: v1)
        radialGravitationForceOnChildrenMultiplierSettingsItem = SettingsItem(name: "Multiplier", value: v2, initialValue: v2)
        negativeRadialGravitationalForceOnSiblingsPowerSettingsItem = SettingsItem(name: "Power", value: v3, initialValue: v3)
        springForceBetweenConnectedNodesPowerSettingsItem = SettingsItem(name: "Power", value: v4, initialValue: v4)
        areaBasedOnTotalChildrensAreaMultiplierSettingsItem = SettingsItem(name: "Multiplier", value: v5, initialValue: v5)
        // Visibility
        unfoldedNodesSettingsGroup = SettingsGroup(name: "Unfolded Nodes", settingsItems: [])
        hiddenNodesSettingsGroup = SettingsGroup(name: "Hidden Nodes", settingsItems: [])
        flattendedNodesSettingsGroup = SettingsGroup(name: "Flattened Nodes", settingsItems: [])
        unfoldedScopesSettingsGroup = SettingsGroup(name: "Unfolded Scopes", settingsItems: [])
        hiddenScopesSettingsGroup = SettingsGroup(name: "Hidden Scopes", settingsItems: [])
        flattendedScopesSettingsGroup = SettingsGroup(name: "Flattened Scopes", settingsItems: [])
    }

}
