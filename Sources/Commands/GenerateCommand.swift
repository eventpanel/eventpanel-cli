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

    init(eventPanelYaml: EventPanelYaml) {
        self.eventPanelYaml = eventPanelYaml
    }

    func execute() async throws {
        ConsoleLogger.message("Generating events from EventPanel.yaml...")

        let plugin = await eventPanelYaml.getPlugin()

        do {
            try await plugin.generator.run()
        } catch {
            throw GenerateCommandError.swiftgenFailed(error.localizedDescription)
        }
    }
}
