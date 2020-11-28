//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Foundation

public struct Settings: Codable {

    // MARK: - Public -
    
    public init() {
        // Force & Geometry
        firstDomains = [
            SettingsDomain(
                name: "Force Settings",
                settingsGroups: [
                    SettingsGroup(
                        name: "",
                        settingsItems: [
                            SettingsItem(name: "Friction", value: .range(value: 0.75, minValue: 0.5, maxValue: 1)),
                            SettingsItem(name: "Negative Radial Force on Siblings", value: .range(value: -1.3, minValue: -2.3, maxValue: -0.3)),
                            SettingsItem(name: "Spring Force on Connected Nodes", value: .range(value: 1.1, minValue: 0.2, maxValue: 2.0))
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
                            SettingsItem(name: "Node Radius", value: .range(value: 64, minValue: 0.1, maxValue: 127.9)),
                            SettingsItem(name: "Arc Width", value: .range(value: 1.5, minValue: 0.1, maxValue: 2.9)),
                            SettingsItem(name: "Source Radius", value: .range(value: 0, minValue: -0.1, maxValue: 0.1)),
                            SettingsItem(name: "Sink Radius", value: .range(value: 0, minValue: -0.1, maxValue: 0.1))
                        ]
                    )
                ]
            )
        ]
        
        // Visibility & Color
        secondDomains = [
            SettingsDomain(
                name: "Visibility Settings",
                settingsGroups: [
                    SettingsGroup(
                        name: "Unfolded Nodes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .unfoldNodes(regex: "")
                        )
                    ),
                    SettingsGroup(
                        name: "Hidden Nodes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .hideNodes(regex: "")
                        )
                    ),
                    SettingsGroup(
                        name: "Flattened Nodes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .flattenNodes(regex: "")
                        )
                    ),
                    SettingsGroup(
                        name: "Unfolded Scopes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .unfoldScopes(regex: "")
                        )
                    ),
                    SettingsGroup(
                        name: "Hidden Scopes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .hideScopes(regex: "")
                        )
                    ),
                    SettingsGroup(
                        name: "Flattened Scopes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .flattenScopes(regex: "")
                        )
                    )
                ]
            ),
            SettingsDomain(
                name: "Color Settings",
                settingsGroups: [
                    SettingsGroup(
                        name: "Colored Nodes",
                        settingsItems: [],
                        preferredNewValue: .deletable(virtualTransformation: .colorNodes(regex: "", color: CodableColor.gray)
                        )
                    ),
                    SettingsGroup(
                        name: "Colored Scopes",
                        settingsItems: [
                            SettingsItem(name: "module", value: .deletable(virtualTransformation: .colorScope(scope: "module", color: CodableColor(systemColor: #colorLiteral(red: 0.4745098039, green: 0.9882352941, blue: 0.9176470588, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "import_decl", value: .deletable(virtualTransformation: .colorScope(scope: "import_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.4745098039, green: 0.9882352941, blue: 0.9176470588, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "class_decl", value: .deletable(virtualTransformation: .colorScope(scope: "class_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.4392156863, green: 0.8470588235, blue: 1, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "struct_decl", value: .deletable(virtualTransformation: .colorScope(scope: "struct_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.4392156863, green: 0.8470588235, blue: 1, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "enum_decl", value: .deletable(virtualTransformation: .colorScope(scope: "enum_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.4392156863, green: 0.8470588235, blue: 1, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "extension_decl", value: .deletable(virtualTransformation: .colorScope(scope: "extension_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.4392156863, green: 0.8470588235, blue: 1, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "var_decl", value: .deletable(virtualTransformation: .colorScope(scope: "var_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.9647058824, green: 0.4823529412, blue: 0.4705882353, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "enum_case_decl", value: .deletable(virtualTransformation: .colorScope(scope: "enum_case_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.9647058824, green: 0.4823529412, blue: 0.4705882353, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "enum_element_decl", value: .deletable(virtualTransformation: .colorScope(scope: "enum_element_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.9647058824, green: 0.4823529412, blue: 0.4705882353, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "func_decl", value: .deletable(virtualTransformation: .colorScope(scope: "func_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.9607843137, green: 0.768627451, blue: 0.5058823529, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "constructor_decl", value: .deletable(virtualTransformation: .colorScope(scope: "constructor_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.9607843137, green: 0.768627451, blue: 0.5058823529, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "destructor_decl", value: .deletable(virtualTransformation: .colorScope(scope: "destructor_decl", color: CodableColor(systemColor: #colorLiteral(red: 0.9607843137, green: 0.768627451, blue: 0.5058823529, alpha: 1)) ?? .gray))),
                            SettingsItem(name: "protocol", value: .deletable(virtualTransformation: .colorScope(scope: "protocol", color: CodableColor(systemColor: #colorLiteral(red: 0.8, green: 0.862745098, blue: 0.8588235294, alpha: 1)) ?? .gray)))
                        ],
                        preferredNewValue: .deletable(virtualTransformation: .colorScopes(regex: "", color: CodableColor.gray)
                        )
                    )
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
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[safe: 0]?.value {
            return value
        } else {
            assertionFailure()
            return 0.75
        }
    }
    public var negativeRadialGravitationalForceOnSiblingsPower: Double {
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[safe: 1]?.value {
            return value
        } else {
            assertionFailure()
            return -1.3
        }
    }
    public var springForceBetweenConnectedNodesPower: Double {
        if case let .range(value, _, _) = forceSettingsGroup.settingsItems[safe: 2]?.value {
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
        if case let .range(value, _, _) = geometrySettingsGroup.settingsItems[safe: 0]?.value {
            return value
        } else {
            assertionFailure()
            return 2
        }
    }
    public var arcWidthMultiplier: Double {
        if case let .range(value, _, _) = geometrySettingsGroup.settingsItems[safe: 1]?.value {
            return value
        } else {
            assertionFailure()
            return 5
        }
    }
    public var sourceRadiusMultiplier: Double {
        if case let .range(value, _, _) = geometrySettingsGroup.settingsItems[safe: 2]?.value {
            return value
        } else {
            assertionFailure()
            return 5
        }
    }
    public var sinkRadiusMultiplier: Double {
        if case let .range(value, _, _) = geometrySettingsGroup.settingsItems[safe: 3]?.value {
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
    
    // MARK: - Internal -
    
    // MARK: Other
    
    var settingsItems: [SettingsItem] {
        (firstDomains + secondDomains)
            .compactMap { $0 }
            .flatMap { $0.settingsGroups }
            .flatMap { $0.settingsItems }
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
        
}
