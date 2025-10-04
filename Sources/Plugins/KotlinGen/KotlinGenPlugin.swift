import Foundation

struct KotlinGenPlugin: Codable {
    let outputFilePath: String
    let packageName: String
    let eventClassName: String
    let documentation: Bool
    let shouldGenerateType: Bool
}

extension KotlinGenPlugin {
    static let `default`: KotlinGenPlugin = .make()
    static let defaultOutputFilePath = "GeneratedAnalyticsEvents.kt"
    
    static func make(
        outputFilePath: String = defaultOutputFilePath
    ) -> KotlinGenPlugin {
        KotlinGenPlugin(
            outputFilePath: outputFilePath,
            packageName: "com.analytics.events",
            eventClassName: "AnalyticsEvent",
            documentation: true,
            shouldGenerateType: true
        )
    }
} 
