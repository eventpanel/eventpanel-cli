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
    private let fileManager: FileManager
    
    init(config: SwiftgenPlugin, fileManager: FileManager = .default) {
        self.config = config
        self.fileManager = fileManager
    }

    func run() throws {
        let scheme = try SchemeManager.read().loadScheme()
        let swiftgenScheme = try SwiftgenWorkspaceScheme(from: scheme)
        try saveScheme(swiftgenScheme)
        try generate()
    }

    func initilize() async throws {
        try createFolderIfNeeded()
        writeSwiftgenTemplate(path: config.templatePath)
        writeSwiftgenYaml(path: config.swiftgenYamlPath)
    }

    private func createFolderIfNeeded() throws {
        let rootPath = try getEventPanelDirectory()
        if !fileManager.fileExists(atPath: rootPath.path) {
            try fileManager.createDirectory(
                at: rootPath,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }

    private func writeSwiftgenYaml(path: String) {
        let encoder = YAMLEncoder()
        let yaml = SwiftgenYaml(
            json: SwiftgenYaml.JSONConfig(
                inputs: "swiftgen_scheme.json",
                outputs: SwiftgenYaml.OutputConfig(
                    templatePath: config.templatePath.replacingOccurrences(of: config.inputDir, with: ""),
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

    private func saveScheme(_ scheme: SwiftgenWorkspaceScheme) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(scheme)

            let eventPanelDir = try getEventPanelDirectory()
            try fileManager.createDirectory(
                at: eventPanelDir,
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Save scheme.json
            let schemeURL = eventPanelDir.appendingPathComponent("swiftgen_scheme.json")
            try data.write(to: schemeURL)

        } catch {
            throw PullCommandError.saveFailed(error.localizedDescription)
        }
    }

    private func getEventPanelDirectory() throws -> URL {
        let currentPath = fileManager.currentDirectoryPath
        return URL(fileURLWithPath: (currentPath as NSString)
            .appendingPathComponent(".eventpanel"))
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
