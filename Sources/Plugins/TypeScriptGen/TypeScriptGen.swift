import Foundation
import Yams
import StencilEventPanelKit

enum TypeScriptGenError: LocalizedError {
    case generateFailed(String)
    case saveFailed(String)

    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate TypeScript file: \(message)"
        case .saveFailed(let message):
            return "Failed to save generated TypeScript file: \(message)"
        }
    }
}

actor TypeScriptGen: CodeGeneratorPlugin {
    private let config: TypeScriptGenPlugin
    private let schemeManagerLoader: SchemeManagerLoader
    private let configFileLocation: ConfigFileLocation
    private let fileManager: FileManager
    private let generator: TypeScriptGenGenerator

    init(
        config: TypeScriptGenPlugin,
        schemeManagerLoader: SchemeManagerLoader,
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.config = config
        self.schemeManagerLoader = schemeManagerLoader
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
        self.generator = TypeScriptGenGenerator(config: config)
    }

    func run() async throws {
        let scheme = try schemeManagerLoader.read()
        let typescriptGenScheme = try TypeScriptGenWorkspaceScheme(from: scheme)
        let stencilTemplate = try TypeScriptGenStencilTemplate.default()

        let rendered = try generator.generate(scheme: typescriptGenScheme, stencilTemplate: stencilTemplate)
        try saveGeneratedCode(rendered: rendered)
    }

    private func saveGeneratedCode(rendered: String) throws {
        do {
            let fileURL = configFileLocation.configDirectory.appendingPathComponent(config.outputFilePath)

            // Create intermediate directories if they don't exist
            let directoryURL = fileURL.deletingLastPathComponent()
            if !fileManager.fileExists(atPath: directoryURL.path) {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }

            try rendered.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            throw TypeScriptGenError.saveFailed(error.localizedDescription)
        }
    }
}
