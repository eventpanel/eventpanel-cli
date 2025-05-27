import Foundation

enum GenerateCommandError: LocalizedError {
    case swiftgenFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .swiftgenFailed(let message):
            return "SwiftGen execution failed: \(message)"
        }
    }
}

final class GenerateCommand {
    private let eventPanelYaml: EventPanelYaml
    private let generatorPluginFactory: GeneratorPluginFactory

    init(eventPanelYaml: EventPanelYaml, generatorPluginFactory: GeneratorPluginFactory) {
        self.eventPanelYaml = eventPanelYaml
        self.generatorPluginFactory = generatorPluginFactory
    }

    func execute() async throws {
        ConsoleLogger.message("Generating events from EventPanel.yaml...")

        let plugin = await eventPanelYaml.getPlugin()
        let generator = generatorPluginFactory.generator(for: plugin)

        do {
            try await generator.run()
        } catch {
            throw GenerateCommandError.swiftgenFailed(error.localizedDescription)
        }
    }
}
