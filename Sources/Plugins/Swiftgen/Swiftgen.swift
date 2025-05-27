import Foundation
import Yams
import StencilSwiftKit

enum SwiftgenError: LocalizedError {
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

actor Swiftgen: CodeGeneratorPlugin {
    private let config: SwiftgenPlugin
    private let schemeManagerLoader: SchemeManagerLoader
    private let fileManager: FileManager
    private let generator: SwiftgenGenerator

    init(
        config: SwiftgenPlugin,
        schemeManagerLoader: SchemeManagerLoader,
        fileManager: FileManager
    ) {
        self.config = config
        self.schemeManagerLoader = schemeManagerLoader
        self.fileManager = fileManager
        self.generator = SwiftgenGenerator(config: config)
    }

    func run() async throws {
        let scheme = try schemeManagerLoader.read()
        let swiftgenScheme = try SwiftgenWorkspaceScheme(from: scheme)
        let stencilTemplate = try SwiftgenStenillTemplate.default()
        
        let rendered = try generator.generate(scheme: swiftgenScheme, stencilTemplate: stencilTemplate)
        try saveGeneratedCode(rendered: rendered)
    }

    private func saveGeneratedCode(rendered: String) throws {
        do {
            let currentPath = fileManager.currentDirectoryPath
            let filePath = (currentPath as NSString).appendingPathComponent(config.generatedEventsPath)
            let fileURL = URL(fileURLWithPath: filePath)

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

            ConsoleLogger.debug("Generated events path: \(filePath)")
            ConsoleLogger.success("Generated events completed successfully")
        } catch {
            throw SwiftgenError.saveFailed(error.localizedDescription)
        }
    }
}
