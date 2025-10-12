import Foundation

final class RemoveCommand {
    private let configProvider: ConfigProvider

    init(configProvider: ConfigProvider) {
        self.configProvider = configProvider
    }

    func execute(eventId: String) async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()

        try await eventPanelYaml.removeEvent(eventId: eventId)

        ConsoleLogger.success("Removed event '\(eventId)'")
    }
}
