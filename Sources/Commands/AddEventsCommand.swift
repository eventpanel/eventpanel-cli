import Foundation

enum AddEventsCommandError: LocalizedError {
    case noEventsFound

    var errorDescription: String? {
        switch self {
        case .noEventsFound:
            return "No events found"
        }
    }
}

final class AddEventsCommand {
    private let apiService: EventPanelAPIService
    private let configProvider: ConfigProvider

    init(apiService: EventPanelAPIService, configProvider: ConfigProvider) {
        self.apiService = apiService
        self.configProvider = configProvider
    }

    func execute(categoryId: String?) async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let source = await eventPanelYaml.getSource()

        let events: [LatestEventData]

        if let categoryId = categoryId {
            events = try await apiService.getEvents(
                categoryId: categoryId,
                source: source
            )
        } else {
            events = try await apiService.getEvents(
                source: source.rawValue
            )
        }

        guard !events.isEmpty else {
            throw AddEventsCommandError.noEventsFound
        }

        let eventsToAdd = events.map { Event(id: $0.eventId, version: $0.version) }

        try await eventPanelYaml.addEvents(eventsToAdd)

        if let categoryId = categoryId {
            ConsoleLogger.success("Successfully added \(events.count) events from category '\(categoryId)'")
        } else {
            ConsoleLogger.success("Successfully added \(events.count) events from source '\(source.rawValue)'")
        }
    }
}
