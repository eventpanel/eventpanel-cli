import Foundation
import Yams
import StencilEventPanelKit

enum KotlinGenError: LocalizedError {
    case generateFailed(String)
    case saveFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate Kotlin file: \(message)"
        case .saveFailed(let message):
            return "Failed to save generated Kotlin file: \(message)"
        }
    }
}

actor KotlinGen: CodeGeneratorPlugin {
    private let config: KotlinGenPlugin
    private let schemeManagerLoader: SchemeManagerLoader
    private let configFileLocation: ConfigFileLocation
    private let fileManager: FileManager
    private let generator: KotlinGenGenerator

    init(
        config: KotlinGenPlugin,
        schemeManagerLoader: SchemeManagerLoader,
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.config = config
        self.schemeManagerLoader = schemeManagerLoader
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
        self.generator = KotlinGenGenerator(config: config)
    }

    func run() async throws {
        let scheme = try schemeManagerLoader.read()
        let kotlinGenScheme = try KotlinGenWorkspaceScheme(from: scheme)
        let stencilTemplate = try KotlinGenStencilTemplate.default()
        
        let rendered = try generator.generate(scheme: kotlinGenScheme, stencilTemplate: stencilTemplate)
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

            ConsoleLogger.debug("Generated Kotlin events path: \(fileURL.relativePath)")
            ConsoleLogger.success("Generated Kotlin events completed successfully")
        } catch {
            throw KotlinGenError.saveFailed(error.localizedDescription)
        }
    }
}
