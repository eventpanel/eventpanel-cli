//
//  SwiftgenPlugin.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 08.05.2025.
//


struct SwiftgenPlugin: Codable {
    static var `default`: SwiftgenPlugin {
        .init(
            templatePath: ".eventpanel/event-panel-template.stencil",
            generatedEventsPath: "./GeneratedAnalyticsEvents.swift",
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }

    let templatePath: String
    let generatedEventsPath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool

    var generator: CodeGeneratorPlugin {
        Swiftgen()
    }
}
