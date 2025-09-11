import Foundation

struct KotlinGenPlugin: Codable {
    let generatedEventsPath: String
    let packageName: String
    let eventClassName: String
    let documentation: Bool
}

extension KotlinGenPlugin {
    static var `default`: KotlinGenPlugin {
        .init(
            generatedEventsPath: "GeneratedAnalyticsEvents.kt",
            packageName: "com.analytics.events",
            eventClassName: "AnalyticsEvent",
            documentation: true
        )
    }
} 
