import Foundation

struct TypeScriptGenPlugin: Codable {
    let outputFilePath: String
    let namespace: String
    let eventClassName: String
    let documentation: Bool
    let shouldGenerateType: Bool
}

extension TypeScriptGenPlugin {
    static let `default`: TypeScriptGenPlugin = .make()
    static let defaultOutputFilePath = "GeneratedAnalyticsEvents.ts"

    static func make(
        outputFilePath: String = defaultOutputFilePath
    ) -> TypeScriptGenPlugin {
        TypeScriptGenPlugin(
            outputFilePath: outputFilePath,
            namespace: "AnalyticsEvents",
            eventClassName: "AnalyticsEvent",
            documentation: true,
            shouldGenerateType: true
        )
    }
}
