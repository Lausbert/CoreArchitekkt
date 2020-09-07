// Copyright © 2020 Stephan Lerner. All rights reserved.

import Foundation

public enum SettingsValue: Codable {

    // MARK: - Internal -

    case range(value: Double, minValue: Double, maxValue: Double)
    case deletable(data: Data)

    enum CodingKeys: CodingKey {
        case range, deletable
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first

        switch key {
        case .range:
            let (value, minValue, maxValue): (Double, Double, Double) = try container.decodeValues(for: .range)
            self = .range(value: value, minValue: minValue, maxValue: maxValue)
        case .deletable:
            let data = try container.decode(Data.self, forKey: .deletable)
            self = .deletable(data: data)
        case .none:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .range(value, minValue, maxValue):
            try container.encodeValues(value, minValue, maxValue, for: .range)
        case let .deletable(data):
            try container.encode(data, forKey: .deletable)
        }
    }
}

extension SettingsValue: Equatable {}
