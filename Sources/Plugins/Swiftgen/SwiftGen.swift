import Foundation
import Yams
import StencilEventPanelKit

enum SwiftGenError: LocalizedError {
    case generateFailed(String)
    case saveFailed(String)

    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate file: \(message)"
        case .saveFailed(let message):
            return "Failed to save generated file: \(message)"
        }
    }
}

actor SwiftGen: CodeGeneratorPlugin {
    private let config: SwiftGenPlugin
    private let schemeManagerLoader: SchemeManagerLoader
    private let configFileLocation: ConfigFileLocation
    private let fileManager: FileManager
    private let generator: SwiftGenGenerator

    init(
        config: SwiftGenPlugin,
        schemeManagerLoader: SchemeManagerLoader,
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.config = config
        self.schemeManagerLoader = schemeManagerLoader
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
        self.generator = SwiftGenGenerator(config: config)
    }

    func run() async throws {
        let scheme = try schemeManagerLoader.read()
        let swiftgenScheme = try SwiftGenWorkspaceScheme(from: scheme)
        let stencilTemplate = try SwiftGenStencilTemplate.default()

        let rendered = try generator.generate(scheme: swiftgenScheme, stencilTemplate: stencilTemplate)
        try saveGeneratedCode(rendered: rendered)
    }

    private func saveGeneratedCode(rendered: String) throws {
        do {
            let fileURL = configFileLocation.configDirectory.appendingPathComponent(config.outputFilePath)

            // Create intermediate directories if they don't exist
            let directoryURL = fileURL.deletingLastPathComponent()
            if !fileManager.fileExists(atPath: directoryURL.path) {
                try fileManager.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }

            try rendered.write(to: fileURL, atomically: true, encoding: .utf8)

            ConsoleLogger.debug("Generated events path: \(fileURL.relativePath)")
            ConsoleLogger.success("Generated events completed successfully")
        } catch {
            throw SwiftGenError.saveFailed(error.localizedDescription)
        }
    }
}
