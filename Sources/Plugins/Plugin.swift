import Foundation

enum Plugin: Codable {
    case swiftgen(SwiftGenPlugin)
    case kotlingen(KotlinGenPlugin)
    case typescriptgen(TypeScriptGenPlugin)

    enum CodingKeys: String, CodingKey {
        case swiftgen
        case kotlingen
        case typescriptgen
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.swiftgen) {
            let plugin = try container.decode(SwiftGenPlugin.self, forKey: .swiftgen)
            self = .swiftgen(plugin)
        } else if container.contains(.kotlingen) {
            let plugin = try container.decode(KotlinGenPlugin.self, forKey: .kotlingen)
            self = .kotlingen(plugin)
        } else if container.contains(.typescriptgen) {
            let plugin = try container.decode(TypeScriptGenPlugin.self, forKey: .typescriptgen)
            self = .typescriptgen(plugin)
        } else {
            throw DecodingError.dataCorruptedError(
                in: try decoder.singleValueContainer(),
                debugDescription: "Unknown plugin type"
            )
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
        case .kotlingen(let plugin):
            let data = try encoder.encode(plugin)
            let pluginDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            try container.encode(["kotlingen": pluginDict?.mapValues { AnyCodable($0) } ?? [:]])
        case .typescriptgen(let plugin):
            let data = try encoder.encode(plugin)
            let pluginDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            try container.encode(["typescriptgen": pluginDict?.mapValues { AnyCodable($0) } ?? [:]])
        }
    }
}
