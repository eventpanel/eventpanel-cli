import Foundation

struct SwiftGenPlugin: Codable {
    let outputFilePath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool
}

extension SwiftGenPlugin {
    static let `default`: SwiftGenPlugin = .make()
    static let defaultOutputFilePath = "GeneratedAnalyticsEvents.swift"

    static func make(
        outputFilePath: String = defaultOutputFilePath,
    ) -> SwiftGenPlugin {
        SwiftGenPlugin(
            outputFilePath: outputFilePath,
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }
}
