import Foundation

enum GenerateCommandError: LocalizedError {
    case generationFailed(String)

    var errorDescription: String? {
        switch self {
        case .generationFailed(let message):
            return "Generation execution failed: \(message)"
        }
    }
}

final class GenerateCommand {
    private let configProvider: ConfigProvider
    private let generatorPluginFactory: GeneratorPluginFactory

    init(configProvider: ConfigProvider, generatorPluginFactory: GeneratorPluginFactory) {
        self.configProvider = configProvider
        self.generatorPluginFactory = generatorPluginFactory
    }

    func execute() async throws {
        ConsoleLogger.message("Generating events from EventPanel.yaml...")

        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let plugin = await eventPanelYaml.getPlugin()
        let generator = generatorPluginFactory.generator(for: plugin)

        do {
            try await generator.run()
        } catch {
            throw GenerateCommandError.generationFailed(error.localizedDescription)
        }
    }
}
