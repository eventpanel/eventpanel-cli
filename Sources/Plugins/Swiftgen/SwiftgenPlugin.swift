//
//  SwiftgenPlugin.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 08.05.2025.
//

import Foundation

struct SwiftgenPlugin: Codable {
    let inputDir: String
    let templatePath: String
    let generatedEventsPath: String
    let namespace: String
    let eventTypeName: String
    let documentation: Bool

    var swiftgenYamlPath: String {
        inputDir + "/swiftgen.yaml"
    }

    private var inputDirURL: URL {
        URL(fileURLWithPath: inputDir)
    }

    func getRelativePath(from path: String) -> String {
        let pathURL = URL(fileURLWithPath: path)
        let inputURL = inputDirURL
        return pathURL.path.replacingOccurrences(of: inputURL.path + "/", with: "")
    }
}

extension SwiftgenPlugin {
    static var `default`: SwiftgenPlugin {
        .init(
            inputDir: ".eventpanel",
            templatePath: ".eventpanel/event-panel-template.stencil",
            generatedEventsPath: "../GeneratedAnalyticsEvents.swift",
            namespace: "AnalyticsEvents",
            eventTypeName: "AnalyticsEvent",
            documentation: true
        )
    }
}
