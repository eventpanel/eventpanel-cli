//
//  SwiftgenPlugin.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 08.05.2025.
//

struct SwiftgenPlugin: Codable {
    static var `default`: SwiftgenPlugin {
        .init(
            inputDir: ".eventpanel",
            templatePath: ".eventpanel/event-panel-template.stencil",
            swiftgenYamlPath: ".eventpanel/swiftgen.yaml",
            generatedEventsPath: "../GeneratedAnalyticsEvents.swift",
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }

    let inputDir: String
    let templatePath: String
    let swiftgenYamlPath: String
    let generatedEventsPath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool

    var generator: CodeGeneratorPlugin {
        Swiftgen(config: self)
    }
}
