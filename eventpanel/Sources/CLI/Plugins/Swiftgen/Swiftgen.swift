//
//  Swiftgen.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 05.05.2025.
//

import Foundation
import Yams

actor Swiftgen: CodeGeneratorPlugin {
    private let config: SwiftgenPlugin

    init(config: SwiftgenPlugin) {
        self.config = config
    }

    func run() throws {
        // generate swiftgen.yaml
        // generate swift scheme
        try generate()
        // remove swiftgen.yaml
        // remove swift scheme
    }

    func initilize() async throws {
        writeSwiftgenTemplate(path: config.templatePath)
        writeSwiftgenYaml(path: config.swiftgenYamlPath)
    }

    private func writeSwiftgenYaml(path: String) {
        let encoder = YAMLEncoder()
        let yaml = SwiftgenYaml(
            json: SwiftgenYaml.JSONConfig(
                inputs: "scheme.json",
                outputs: SwiftgenYaml.OutputConfig(
                    templatePath: config.templatePath.replacingOccurrences(of: config.root, with: ""),
                    output: config.generatedEventsPath,
                    params: SwiftgenYaml.OutputParams(
                        enumName: config.namespace,
                        eventClassName: config.eventTypeName,
                        documentation: config.documentation
                    )
                )
            )
        )
        do {
            let yamlString = try encoder.encode(yaml)
            try yamlString.write(toFile: path, atomically: true, encoding: .utf8)
        } catch {
            ConsoleLogger.error("Error writing Swiftgen template to file: \(error)")
        }
    }

    func writeSwiftgenTemplate(path: String) {
        do {
            try swiftgenStenillTemplate.write(toFile: path, atomically: true, encoding: .utf8)
        } catch {
            ConsoleLogger.error("Error writing Swiftgen template to file: \(error)")
        }
    }

    private func generate() throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [
            "swiftgen",
            "config",
            "run",
            "--config",
            config.swiftgenYamlPath
        ]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus == 0 {
            ConsoleLogger.success("SwiftGen completed successfully")
        } else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                throw GenerateCommandError.swiftgenFailed(output)
            }
            throw GenerateCommandError.swiftgenFailed("Unknown error")
        }
    }
}
