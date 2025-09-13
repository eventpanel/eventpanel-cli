import Foundation

struct SwiftGenPlugin: Codable {
    let generatedEventsPath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool
}

extension SwiftGenPlugin {
    static func make(
        generatedEventsPath: String = "GeneratedAnalyticsEvents.swift",
    ) -> SwiftGenPlugin {
        SwiftGenPlugin(
            generatedEventsPath: generatedEventsPath,
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }
}
