//
//  Plugin.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 05.05.2025.
//

import Foundation

enum Plugin: Codable {
    case swiftgen(SwiftgenPlugin)

    var generator: CodeGeneratorPlugin {
        switch self {
        case .swiftgen(let plugin):
            return plugin.generator
        }
    }

    enum CodingKeys: String {
        case swiftgen
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: [String: AnyCodable]].self)

        guard let (type, rawData) = dict.first else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "No plugin found.")
        }

        let pluginData = try JSONSerialization.data(withJSONObject: rawData, options: [])
        let decoder = JSONDecoder()

        switch type {
        case "swiftgen":
            let plugin = try decoder.decode(SwiftgenPlugin.self, from: pluginData)
            self = .swiftgen(plugin)
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown plugin type: \(type)")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let encoder = JSONEncoder()

        switch self {
        case .swiftgen(let plugin):
            let data = try encoder.encode(plugin)
            let pluginDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            try container.encode(["swiftgen": pluginDict?.mapValues { AnyCodable($0) } ?? [:]])
        }
    }
}

