import Foundation
import Get

enum OutdatedCommandError: LocalizedError {
    case eventCheckFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .eventCheckFailed(let message):
            return "Failed to check event updates: \(message)"
        }
    }
}

// MARK: - Models

private struct OutdatedEvent {
    let eventId: String
    let currentVersion: Int
    let latestVersion: Int
    
    var displayString: String {
        "- \(eventId) \(currentVersion) -> latest version \(latestVersion)"
    }
}

final class OutdatedCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml

    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
    }
    
    func execute() async throws {
        ConsoleLogger.message("Checking for outdated events...")

        let events = await eventPanelYaml.getEvents()
        
        let outdatedEvents = try await checkEventsForUpdates(events)
        displayResults(outdatedEvents)
    }
    
    // MARK: - Private Methods
    
    private func checkEventsForUpdates(_ events: [Event]) async throws -> [OutdatedEvent] {
        do {
            let requestBody = EventLatestRequest(events: events.map { event in
                EventLatestRequestItem(
                    eventId: event.name,
                    version: event.version ?? 1
                )
            })
            let eventVersions = events.reduce(into: [String: Int]()) { result, event in
                result[event.name] = event.version
            }

            let response: Response<EventLatestResponse> = try await networkClient.send(
                Request(
                    path: "api/external/events/latest/list",
                    method: .post,
                    body: requestBody
                )
            )

            return response.value.events.compactMap { event in
                guard
                    let currentVersion = eventVersions[event.eventId],
                    currentVersion < event.version
                else { return nil }
                return OutdatedEvent(
                    eventId: event.eventId,
                    currentVersion: currentVersion,
                    latestVersion: event.version
                )
            }
        } catch let error as APIError {
            throw OutdatedCommandError.eventCheckFailed(error.localizedDescription)
        } catch {
            throw OutdatedCommandError.eventCheckFailed(error.localizedDescription)
        }
    }
    
    private func displayResults(_ outdatedEvents: [OutdatedEvent]) {
        if outdatedEvents.isEmpty {
            ConsoleLogger.message("All events are up to date")
            return
        }
        
        ConsoleLogger.message("\nThe following event updates are available:")
        for event in outdatedEvents {
            ConsoleLogger.message(event.displayString)
        }
    }
}
