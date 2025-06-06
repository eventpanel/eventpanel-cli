import Foundation

struct SwiftGenPlugin: Codable {
    let generatedEventsPath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool
}

extension SwiftGenPlugin {
    static var `default`: SwiftGenPlugin {
        .init(
            generatedEventsPath: "GeneratedAnalyticsEvents.swift",
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }
}
