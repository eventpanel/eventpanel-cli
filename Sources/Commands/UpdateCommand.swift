import Foundation
import Get

enum UpdateCommandError: LocalizedError {
    case eventCheckFailed(String)
    case noEventsToUpdate
    case eventNotFound(String)
    case eventsAreNotAdded([String])

    var errorDescription: String? {
        switch self {
        case .eventCheckFailed(let message):
            return "Failed to check event updates: \(message)"
        case .noEventsToUpdate:
            return "No events to update"
        case .eventNotFound(let eventId):
            return "Unable to find a specification for '\(eventId)'"
        case .eventsAreNotAdded(let eventIds):
            return "The following events are not added to EventPanel.yaml: \(eventIds.joined(separator: ", "))"
        }
    }
}

final class UpdateCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml

    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
    }
    
    func execute(eventIds: [String]) async throws {
        if eventIds.count == 1, let eventId = eventIds.first {
            try await updateSingleEvent(eventId: eventId)
        } else if eventIds.isEmpty {
            try await updateAllEvents()
        } else {
            try await updateEvents(eventIds: Set(eventIds))
        }
    }
    
    // MARK: - Private Methods

    private func updateSingleEvent(eventId: String) async throws {
        ConsoleLogger.message("Checking for updates to event '\(eventId)'...")

        let events = await eventPanelYaml.getEvents()
        
        // Verify event exists in configuration
        guard let event = events.first(where: { $0.id == eventId }) else {
            throw UpdateCommandError.eventNotFound(eventId)
        }
        
        let currentVersion = event.version ?? 1
        
        do {
            let response: Response<EventLatestRequestItem> = try await networkClient.send(
                Request(
                    path: "api/external/events/latest/\(eventId)",
                    method: .get
                )
            )

            let updatedEvent = response.value
            if updatedEvent.version != currentVersion {
                // Update event version
                try await eventPanelYaml.updateEvent(
                    eventId: eventId,
                    version: updatedEvent.version
                )
                ConsoleLogger.success("Updated event '\(eventId)' to version \(updatedEvent.version)")
            } else {
                ConsoleLogger.success("The event '\(eventId)' has latest version")
            }
        } catch let error as APIError {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        } catch {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        }
    }
    
    private func updateAllEvents() async throws {
        try await updateEvents(eventIds: nil)
    }

    private func updateEvents(eventIds: Set<String>?) async throws {
        ConsoleLogger.message("Checking for event updates...")

        // Read YAML file
        let events = await eventPanelYaml.getEvents()
        let eventVersions = events.reduce(into: [String: Int]()) { result, event in
            result[event.id] = event.version
        }

        if let eventIds {
            try validateEventsAreExist(events: events, updateEventIds: eventIds)
        }

        guard !events.isEmpty else {
            throw UpdateCommandError.noEventsToUpdate
        }

        do {
            let requestBody = EventLatestRequest(events: events.map {
                EventLatestRequestItem(
                    eventId: $0.id,
                    version: $0.version ?? 1
                )
            })

            // Check if event has a new version
            let response: Response<EventLatestResponse> = try await networkClient.send(
                Request(
                    path: "api/external/events/latest/list",
                    method: .post,
                    body: requestBody
                )
            )

            var updatedEvents = 0
            for event in response.value.events where eventIds?.contains(event.eventId) ?? true {
                guard eventVersions[event.eventId] != event.version else { continue }
                try await eventPanelYaml.updateEvent(
                    eventId: event.eventId,
                    version: event.version
                )
                updatedEvents += 1
            }
            if updatedEvents > 0 {
                ConsoleLogger.success("All events are successfully up to date.")
            } else {
                ConsoleLogger.success("Event synchronization complete. No changes detected");
            }
        } catch let error as APIError {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        } catch {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        }
    }

    private func validateEventsAreExist(events:  [Event], updateEventIds: Set<String>) throws {
        let yamlFileEventIds = Set(events.map(\.id))
        let notExistedEvents = updateEventIds.subtracting(yamlFileEventIds)
        if !notExistedEvents.isEmpty {
            throw UpdateCommandError.eventsAreNotAdded(Array(notExistedEvents))
        }
    }
}
