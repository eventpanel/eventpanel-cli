import Foundation

struct SwiftgenPlugin: Codable {
    let generatedEventsPath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool
}

extension SwiftgenPlugin {
    static var `default`: SwiftgenPlugin {
        .init(
            generatedEventsPath: "GeneratedAnalyticsEvents.swift",
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }
}
