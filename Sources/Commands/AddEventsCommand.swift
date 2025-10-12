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

    func execute(categoryId: String?, categoryName: String?) async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let source = await eventPanelYaml.getSource()

        let events: [LatestEventData]

        if let categoryId = categoryId {
            events = try await apiService.getEvents(
                categoryId: categoryId,
                source: source
            )
        } else if let categoryName = categoryName {
            events = try await apiService.getEventsByCategoryName(
                categoryName: categoryName,
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
        let addedEvents = try await eventPanelYaml.addEvents(eventsToAdd)

        if addedEvents.isEmpty {
            ConsoleLogger.success("All events are already present")
        } else {
            ConsoleLogger.success("Successfully added events:\n- \(addedEvents.map(\.id).joined(separator: "\n- "))")
        }
    }
}
