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

    init(
        config: SwiftgenPlugin,
        schemeManagerLoader: SchemeManagerLoader,
        fileManager: FileManager
    ) {
        self.config = config
        self.schemeManagerLoader = schemeManagerLoader
        self.fileManager = fileManager
    }

    func run() async throws {
        let scheme = try schemeManagerLoader.read()
        let swiftgenScheme = try SwiftgenWorkspaceScheme(from: scheme)

        let rendered = try render(swiftgenScheme: swiftgenScheme)
        try generate(rendered: rendered)
    }

    private func render(swiftgenScheme: SwiftgenWorkspaceScheme) throws -> String {
        let stencillTemplate = try SwiftgenStenillTemplate.default()
        let environment = stencilSwiftEnvironment(
            templates: [stencillTemplate.name: stencillTemplate.template],
            templateClass: StencilSwiftTemplate.self,
            trimBehaviour: .nothing
        )
        let template = TemplateContext(files: [File(document: Document(data: swiftgenScheme))])
        let parameters = try codableToDictionary(
            SwiftgenParams(
                enumName: config.namespace,
                eventClassName: config.eventTypeName,
                documentation: config.documentation
            ),
            keyEncodingStrategy: .useDefaultKeys
        )!
        let context = try codableToDictionary(template)!
        let dict = try StencilContext.enrich(context: context, parameters: parameters, environment: [:])

        do {
            let rendered = try environment.renderTemplate(
                name: stencillTemplate.name,
                context: dict
            )
            return rendered
        } catch {
            throw SwiftgenError.generateFailed(error.localizedDescription)
        }
    }

    private func generate(rendered: String) throws {
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
